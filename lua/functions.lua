local M = {}

local function pathIsTestFile(path)
  return string.match(path, '.*%.spec%.ts')
end

local function getRootFolder(bufferPath)
  local backendPath = string.match(bufferPath, '.*backend')
  if backendPath then
    return backendPath
  end

  local appPatientPath = string.match(bufferPath, '.*app%-patient/patient')
  if appPatientPath then
    return appPatientPath
  end

  local appManagePath = string.match(bufferPath, '.*app%-manage/manage')
  if appManagePath then
    return appManagePath
  end

  local sharedPath = string.match(bufferPath, '.*shared')
  if sharedPath then
    return sharedPath
  end

  local regionPath = string.match(bufferPath, '.*region')
  if regionPath then
    return regionPath
  end

  local globalPath = string.match(bufferPath, '.*global')
  if globalPath then
    return globalPath
  end

  local dentallyMockPath = string.match(bufferPath, '.*dentally%-mock')
  if dentallyMockPath then
    return dentallyMockPath
  end

  print 'No root folder found!'
end

local function StripWhitespace(str)
  return string.gsub(str, '%s+', '')
end

local function getMarkedPaneId()
  local paneId = StripWhitespace(vim.fn.system 'tmux display -p -t "~" "#D"')
  if paneId == nil or paneId == '' then
    local newPaneId = StripWhitespace(vim.fn.system('tmux split-window -d -h -P -F "#{pane_id}"', true))

    vim.fn.system('tmux select-pane -m -t ' .. newPaneId, true)
    return newPaneId
  end
  return paneId
end

local function runInPane(cmd)
  local paneId = getMarkedPaneId()

  vim.fn.system('(tmux send-keys -t ' .. paneId .. ' -X cancel || true) && tmux send-keys -t ' .. paneId .. ' "' .. cmd .. '" Enter', true)
end

local function file_exists(name)
  local f = io.open(name, 'r')
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

local function getCurrentTestFile()
  local bufferPath = vim.api.nvim_buf_get_name(0)
  local isTestFile = pathIsTestFile(bufferPath)

  if isTestFile then
    return bufferPath
  else
    local testFile = string.gsub(bufferPath, '%.ts', '%.spec%.ts')
    if file_exists(testFile) then
      return testFile
    end
  end
end

local function getPreviousDecribeBlock(content, cursorRow)
  local row = cursorRow
  while true do
    if row == 0 then
      break
    end

    local rowContent = content[row]
    if rowContent ~= nil then
      local match = string.match(rowContent, '.*describe%(["\'](.-)["\']%,')
      if match then
        return match
      end
    end
    row = row - 1
  end
end

local function getNearestTest(content, cursorRow)
  local row = cursorRow
  while true do
    if row == 0 then
      break
    end

    local rowContent = content[row]
    if rowContent ~= nil then
      local match = string.match(rowContent, '.*it%(["\'](.-)["\']%,')
      if match then
        return match
      end
    end
    row = row - 1
  end

  row = cursorRow + 1
  while true do
    if row == #content then
      break
    end

    local rowContent = content[row]
    if rowContent ~= nil then
      local match = string.match(rowContent, '.*it%(["\'](.-)["\']%,')
      if match then
        return match
      end
    end

    row = row + 1
  end
end

M.TmuxOpen = function()
  runInPane ''
end

M.TmuxRepeat = function()
  runInPane 'Up'
end

M.TmuxTestAll = function()
  local bufferPath = vim.api.nvim_buf_get_name(0)

  local rootFolder = getRootFolder(bufferPath)
  if rootFolder then
    runInPane('cd ' .. rootFolder .. ' && npm run test')
    return
  end
end

M.TmuxTestFile = function()
  local testFilePath = getCurrentTestFile()
  if not testFilePath then
    print 'No test file found!'
    return
  end
  local rootFolder = getRootFolder(testFilePath)
  if not rootFolder then
    print 'No root folder found!'
    return
  end
  runInPane('cd ' .. rootFolder .. ' && npm run test ' .. testFilePath)
end

M.TmuxTestNearest = function()
  local bufferPath = vim.api.nvim_buf_get_name(0)
  local isTestFile = pathIsTestFile(bufferPath)
  if not isTestFile then
    print 'Not a test file!'
    return
  end

  local content = vim.api.nvim_buf_get_lines(0, 0, vim.api.nvim_buf_line_count(0), false)
  local row, _ = unpack(vim.api.nvim_win_get_cursor(0))

  local match = getNearestTest(content, row)
  if match == nil then
    print 'No test found!'
    return
  end

  local describeBlock = getPreviousDecribeBlock(content, row)
  if describeBlock ~= nil then
    match = describeBlock .. ' ' .. match
  end

  local rootFolder = getRootFolder(bufferPath)
  if rootFolder then
    runInPane('cd ' .. rootFolder .. ' && npm test ' .. bufferPath .. " -- -t '\"'" .. match .. "'\"'")
    return
  end
end

M.ToggleTest = function()
  local bufferPath = vim.api.nvim_buf_get_name(0)
  local isTestFile = pathIsTestFile(bufferPath)
  if isTestFile then
    local implementationFile = string.gsub(bufferPath, '%.spec%.ts', '.ts')
    if file_exists(implementationFile) then
      vim.api.nvim_command('edit ' .. implementationFile)
    else
      print('No implementation file found (' .. implementationFile .. ')')
    end

    return
  else
    local testFile = string.gsub(bufferPath, '%.ts', '.spec.ts')
    if file_exists(testFile) then
      vim.api.nvim_command('edit ' .. testFile)
    else
      print('No test file found (' .. testFile .. ')')
    end

    return
  end
end

M.ToggleHtml = function()
  local bufferPath = vim.api.nvim_buf_get_name(0)
  local isHtmlFile = string.match(bufferPath, '.*%.component%.html')
  if isHtmlFile then
    local implementationFile = string.gsub(bufferPath, '%.component%.html', '.component.ts')
    if file_exists(implementationFile) then
      vim.api.nvim_command('edit ' .. implementationFile)
    else
      print('No implementation file found (' .. implementationFile .. ')')
    end

    return
  else
    local htmlFile = string.gsub(bufferPath, '%.component%.ts', '.component.html')
    if file_exists(htmlFile) then
      vim.api.nvim_command('edit ' .. htmlFile)
    else
      print('No html file found (' .. htmlFile .. ')')
    end

    return
  end
end

M.ShortGuid = function()
  local template = 'xxxxxxxx'
  local guid = string.gsub(template, '[xy]', function(c)
    local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
    return string.format('%x', v)
  end)

  local pos = vim.api.nvim_win_get_cursor(0)[2]
  local line = vim.api.nvim_get_current_line()

  local next_char = line:sub(pos + 2, pos + 2)

  local insertAtIndex = pos
  if next_char == "'" or next_char == '"' then
    insertAtIndex = pos + 1
  end

  local nline = line:sub(0, insertAtIndex) .. guid .. line:sub(insertAtIndex + 1)
  vim.api.nvim_set_current_line(nline)
end

M.SearchInfrastructure = function()
  local bufferPath = vim.api.nvim_buf_get_name(0)

  local searchString = string.match(bufferPath, '.*(src.*).ts')
  if not searchString then
    print 'no search string found'
    return
  end
  require('telescope.builtin').grep_string { search = searchString .. '.handler' }
end

return M
