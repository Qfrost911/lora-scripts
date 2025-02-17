$Env:HF_HOME = "huggingface"
$Env:PIP_DISABLE_PIP_VERSION_CHECK = 1
$Env:PIP_NO_CACHE_DIR = 1
$Env:PIP_INDEX_URL = "https://mirror.baidu.com/pypi/simple"
function InstallFail {
    Write-Output "安装失败。"
    Read-Host | Out-Null ;
    Exit
}

function Check {
    param (
        $ErrorInfo
    )
    if (!($?)) {
        Write-Output $ErrorInfo
        InstallFail
    }
}

if (!(Test-Path -Path "venv")) {
    Write-Output "正在创建虚拟环境..."
    python -m venv venv
    Check "创建虚拟环境失败，请检查 python 是否安装完毕以及 python 版本是否为64位版本的python 3.10、或python的目录是否在环境变量PATH内。"
}

.\venv\Scripts\activate
Check "激活虚拟环境失败。"

Set-Location .\sd-scripts
Write-Output "安装程序所需依赖 (已进行国内加速，若在国外或无法使用加速源请换用 install.ps1 脚本)"
$install_torch = Read-Host "是否需要安装 Torch+xformers? [y/n] (默认为 y)"
if ($install_torch -eq "y" -or $install_torch -eq "Y" -or $install_torch -eq ""){
    pip install torch==2.2.1+cu118 torchvision==0.17.1+cu118 -f https://mirror.sjtu.edu.cn/pytorch-wheels/torch_stable.html
    Check "torch 安装失败，请删除 venv 文件夹后重新运行。"
    pip install -U -I --no-deps xformers==0.0.23+cu118
    Check "xformers 安装失败。"
}

Write-Output "安装 bitsandbytes..."
pip install bitsandbytes==0.41.1 --index-url https://jihulab.com/api/v4/projects/140618/packages/pypi/simple

pip install --upgrade -r requirements.txt
Check "sd-scripts 依赖安装失败。"

Set-Location ..
pip install --upgrade -r requirements_win.txt
Check "训练界面依赖安装失败。"

Write-Output "安装完毕"
Read-Host | Out-Null ;
