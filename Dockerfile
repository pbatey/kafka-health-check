FROM scratch
EXPOSE 8000
ADD main .
CMD ["./main"]
