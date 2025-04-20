FROM alpine/git AS base

ARG TAG=latest
RUN git clone https://github.com/wotakumoe/Wotaku.git && \
    cd Wotaku && \
    ([[ "$TAG" = "latest" ]] || git checkout ${TAG})
    # rm -rf .git

FROM node AS build

WORKDIR /Wotaku
COPY --from=base /git/Wotaku .
RUN npm install --global pnpm && \
    pnpm install && \
    pnpm docs:build

FROM lipanski/docker-static-website

COPY --from=build /Wotaku/docs/.vitepress/dist .
