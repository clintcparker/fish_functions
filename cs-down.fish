function cs-down --wraps='ssh -TO exit cs' --description 'alias cs-down=ssh -TO exit cs'
  ssh -TO exit cs $argv; 
end
