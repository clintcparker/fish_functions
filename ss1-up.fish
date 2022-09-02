function cs-up --wraps='ssh  -fNTM cs' --description 'alias cs-up=ssh  -fNTM cs'
  ssh  -fNTM cs $argv; 
end
