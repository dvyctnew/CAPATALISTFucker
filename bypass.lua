for f, g in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
if g:FindFirstChild("__FUNCTION") then
                    g:Destroy()
end
end
-- after 5 minutes it will kick you.
