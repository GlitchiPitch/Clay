local star = {
    {2, 7}, {3, 6},
    {3, 7}, {3, 8},
    {4, 4}, {4, 5},
    {4, 6}, {4, 8},
    {4, 9}, {4, 10},
    {5, 4}, {5, 10},
    {6, 3}, {6, 4},
    {6, 10}, {6, 11},
    {7, 2}, {7, 3},
    {7, 11}, {7, 12},
    {8, 3}, {8, 4}, 
    {8, 10}, {8, 11},
    {9, 4}, {9, 10},
    {10, 4}, {10, 5},
    {10, 6}, {10, 8},
    {10, 9}, {10, 10},
    {11, 6}, {11, 7},
    {11, 8}, {12, 7}
}

local defaultMatrix = table.create(13, table.create(13, 0))
function fillMatrix(matrixForFill: {})
    for i, v in matrixForFill do
        defaultMatrix[v[1]][v[2]] = 1
    end
end

fillMatrix(star)
print(defaultMatrix)
