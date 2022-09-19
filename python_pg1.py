

def Parser(string):
    string = string.replace(' ', '').replace(',}', '}')
    openFlowerBracket = 0
    tempToken = ''
    output = []
    for i in string:
        if i == '{':
            if openFlowerBracket > 0:
                tempToken += i
            openFlowerBracket += 1
        elif i == '}':
            openFlowerBracket -= 1
            if openFlowerBracket == 0:
                # print(tempToken)
                output = tokeniseString(tempToken, output)
            else:
                tempToken += i
        else:
            tempToken += i
    if openFlowerBracket != 0:
        raise Exception('Syntax Error')
    return output


def tokeniseString(token, output):
    temp = ''
    openFlowerBracket = 0
    for i in token:
        if i == '{':
            openFlowerBracket += 1
        elif i == '}':
            openFlowerBracket -= 1
        if (i == ',' or i == '}') and openFlowerBracket == 0:
            if i == '}':
                temp += i
            if temp:
                output = addToOutput(temp, output)
            temp = ''
        else:
            temp += i
    output = addToOutput(temp, output)
    return output


def addToOutput(token, output):
    # print(token)
    temp = []
    if token[0] == '{':
        output.append(Parser(token))
    elif not '=' in token:
        output.append(int(token))
    else:
        if not '...' in token:
            key, val = token.split('=')
            key = key[1:-1]
            # print(val)
            output = output + \
                [0 for i in range(len(output), int(key))] + [int(val)]
        else:
            keys, val = token.split('=', 1)
            if '{' in val:
                val = Parser(val)
            keys = keys[1:-1].split("...")
            dump = []
            output = output + [0 for i in range(len(output), int(keys[0]))]
            for i in range(int(keys[0]), int(keys[1])+1):
                output.append(val)
    return output


if __name__ == '__main__':


    print('Please input the language grammer...\n')
    string = str(input())

    print('Input:', string)
    parsed_string = Parser(string)
    print('Output:', parsed_string)
