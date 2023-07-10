/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE Customer lending i/c termination')           */
/*********************************************************************/
/*                                                                   */
/*       Midas - Lending Module                                      */
/*                                                                   */
/*       LEC0004 - Lending I/C Termination                           */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD049139           Date 16Jun23              */
/*       Prev Amend No. MD046248           Date 27Oct17              */
/*                      CCB023             Date 06Aug12              */
/*                      CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*                      CSC042             Date 16Feb09              */
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CPK024             Date 12Apr06              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPK009             Date 09Aug99              */
/*                      105519             Date 23Jan98              */
/*                      CCB001 *CREATE     DATE 01Mar95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD049139 - Initialize data area for CLE025                  */
/*                 - MD061267 - Credit Lines (CLE025) fixes          */
/*       MD046248 - Finastra Rebranding                              */
/*       CCB023 - COB Restructure - Input Cycle Termination          */
/*                Restructuring                                      */
/*       CLE134 - Past Due Call Loan Processing (Recompile)          */
/*       CSC042 - Close of Business Performance Enhancements         */
/*                Only call LE1070 for the specific facility         */
/*                for which the history needs to be extracted.       */
/*       CPK024 - Packaging of MPlus 1.2.1. Copy sources needed by   */
/*                UTC0012.                                           */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       105519 - Override CLINT share (*NO) as 2 nested programs    */
/*                access it one for update the other for i/p.        */
/*                Change confo and Pay/rec indicators to NN.         */
/*       CCB001 - CoB Enhancement (Batch Processing)                 */
/*                                                                   */
/*********************************************************************/
             PGM

             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                                   /*MD049139*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                                   /*MD049139*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                                   /*MD049139*/
             DCL        VAR(&DSFDY) TYPE(*CHAR) LEN(200)                                /*MD049139*/
/***COPY*LECPYSRC,LEC0004INT*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,LEC0004INT                                          */                   /*CPK024*/

             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')

/* Global monitor message */

             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

/** Check if CLE025 feature if on */                                                    /*MD049139*/
                                                                                        /*MD049139*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                     /*MD049139*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                     /*MD049139*/
             CHGVAR     VAR(&SARD) VALUE('CLE025')                                      /*MD049139*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &DSFDY)                    /*MD049139*/
                                                                                        /*MD049139*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)                              /*MD049139*/
             CHGDTAARA  DTAARA(CLE025DTA) VALUE('Y')                                    /*MD049139*/
             ENDDO                                                                      /*MD049139*/
             ELSE       CMD(DO)                                                         /*MD049139*/
             CHGDTAARA  DTAARA(CLE025DTA) VALUE('N')                                    /*MD049139*/
             ENDDO                                                                      /*MD049139*/
                                                                                        /*MD049139*/
/***COPY*LECPYSRC,LEC0004MPS*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,LEC0004MPS                                          */                   /*CPK024*/

/**********  STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))            /*CPK009*/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                              /*CPK009*/
             MONMSG     MSGID(CPF8351)

             CHGDTAARA  DTAARA(LESTAT (6 2)) VALUE('NN')            /* 105519 */
             OVRDBF     FILE(CLOAN) SHARE(*NO)                      /* 105519 */
             OVRDBF     FILE(FCLTY) SHARE(*NO)                                            /*CSC042*/
             OVRDBF     FILE(LEFEETPD) FRCRATIO(1)                                        /*CSC042*/
             OVRDBF     FILE(SDCURRPD) SHARE(*NO)                                         /*CSC042*/
             CALL       PGM(LEC04)
             DLTOVR     FILE(CLOAN)                                 /* 105519 */
             DLTOVR     FILE(FCLTY)                                                       /*CCB023*/
             DLTOVR     FILE(LEFEETPD)                                                    /*CCB023*/
             DLTOVR     FILE(SDCURRPD)                                                    /*CCB023*/

             IF         COND(%SWITCH(XXXXXXX1)) THEN(GOTO +
                          CMDLBL(ABNOR))

/***COPY*LECPYSRC,LEC0004MPE*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,LEC0004MPE                                          */                   /*CPK024*/

             GOTO       CMDLBL(END)

 ABNOR:
/***COPY*LECPYSRC,LEC0004ERR*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,LEC0004ERR                                          */                   /*CPK024*/

             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)

             SNDMSG     MSG('LEC0004 ended abnormally') TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)

 END:
/***COPY*LECPYSRC,LEC0004END*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,LEC0004END                                          */                   /*CPK024*/

             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')

             ENDPGM
