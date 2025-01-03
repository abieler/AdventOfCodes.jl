using BenchmarkTools
using StaticArrays

const directions = (
    CartesianIndex(-1, 0),
    CartesianIndex(1, 0),
    CartesianIndex(0, 1),
    CartesianIndex(0, -1),
    CartesianIndex(-1, 1),
    CartesianIndex(1, 1),
    CartesianIndex(-1, -1),
    CartesianIndex(1, -1)
)

function countxmas(CM, directions)
    N, M = size(CM)
    cnt = 0
    word = MVector{4,Char}('X', '.', '.', '.')
    xmas = SVector{4,Char}('X', 'M', 'A', 'S')
    pos = CartesianIndex(0, 0)
    @inbounds for idx in CartesianIndices(CM)
        if CM[idx] != 'X'
            continue
        end
        for direction in directions
            word[2:4] .= '.'
            @inbounds for l = 1:3
                pos = idx + (l * direction)
                (1 <= pos[1] <= N && 1 <= pos[2] <= M) || break
                word[l+1] = CM[pos]
            end
            if word == xmas
                cnt += 1
            end
        end
    end
    return cnt
end


filename = "input.txt"
data = filename |> readlines .|> l -> reduce(hcat, l)
charmatrix = vcat(data...)
@benchmark countxmas(charmatrix, directions)

