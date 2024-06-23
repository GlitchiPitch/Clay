from PIL import Image

def returnFrames(path: str):
    gif = Image.open(path)
    frames = []
    try:
        while True:
            frames.append(gif.copy())
            gif.seek(gif.tell() + 1)
    except EOFError:
        pass

    for i, frame in enumerate(frames):
        frame.save(f'frame_{i}.png', format='PNG')
    
    return frames

def returnMatrix(frames):
    # Open the image file
    image = frames[0]
    image = image.convert('L')

    # Resize the image to (13, 13) using bilinear interpolation
    resized_image = image.resize((13, 13), Image.BILINEAR)

    # Get the pixel values as a list
    pixels = list(resized_image.getdata())

    # Convert the pixel values to a matrix
    matrix_width = resized_image.width
    matrix_height = resized_image.height
    matrix = [[pixels[row * matrix_width + col] for col in range(matrix_width)] for row in range(matrix_height)]

    # Convert the pixel values to binary (0 or 1)
    threshold = 128
    binary_matrix = [[0 if val > threshold else 1 for val in row] for row in matrix]

    return binary_matrix

def get_filled_cells_indexies(matrix):
    filled_cells = []
    for x in range(len(matrix)):
        for y in range(len(matrix[x])):
            if matrix[x][y] == 1:
                filled_cells.append((x + 1, y + 1))
    return filled_cells

def show_matrix(matrix):
    for row in matrix:
        print(row)


frames = returnFrames('Images\JdlV_osc_3.169.gif')
matrix = returnMatrix(frames)
show_matrix(matrix)
filled_cells = get_filled_cells_indexies(matrix)
print(filled_cells)