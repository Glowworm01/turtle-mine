-- Auto update and run program
local args = { ... }
local programName = 'strip_mine'
local programCode = '6FtTMN7e'

if (fs.exists(programName) == false or args[1] == 'update') then
    print("Updating program...")
    shell.run('rm ' .. programName)
    shell.run('pastebin get ' .. programCode .. ' ' .. programName)
    print("Updated!")
end

print('Starting Strip Mine Program')
shell.run(programName)