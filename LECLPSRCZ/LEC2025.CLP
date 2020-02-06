/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE Check database for duplicate PCRFs')         */
/*********************************************************************/
/*                                                                   */
/*       Midas - Customer Lending Module                             */
/*                                                                   */
/*       LEC2025 - Check For Duplicate PCRFs                         */
/*                                                                   */
/*       (c) Finastra International Limited 2003                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      209692  *CREATE    Date 19Mar03              */
/*                      Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CLE134 - Past Due Call Loan Processing (Recompile)          */
/*       209692 - Ensure that new transactions always have a unique  */
/*                PCRF (PC reference) by checking LF/LEPCRFL1        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PCRF)
 
             DCL        VAR(&PCRF) TYPE(*CHAR) LEN(15)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(4)
             DCL        VAR(&RTNCODE) TYPE(*CHAR) LEN(9)
             DCL        VAR(&ERRMSG) TYPE(*CHAR) LEN(78)
 
/*/COPY WNCPYSRC,LEC2025INT                                          */
 
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2003')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
             CRTDTAARA  DTAARA(QTEMP/MIDASMSG) TYPE(*CHAR) LEN(800) +
                          VALUE(' ')
             MONMSG     MSGID(CPF1023)
 
/*/COPY WNCPYSRC,LEC2025MPS                                          */
 
/* Check whether PCRF supplied is unique */
 
             CALL       PGM(LE2025) PARM(&PCRF &TYPE &RTNCODE &ERRMSG)
 
             IF         COND(&RTNCODE *NE '         ') +
                          THEN(CHGDTAARA DTAARA(MIDASMSG (101 78)) +
                          VALUE(&ERRMSG))
 
             ELSE       CMD(CHGDTAARA DTAARA(MIDASMSG (101 67)) +
                          VALUE('PC Reference ' *CAT &PCRF *CAT ' +
                          has not already been used within Midas'))
 
/* Display results to user */
 
             CALL       PGM(SCC0010) PARM('LE2025' 'ENTER' ' ')
 
/* Database error processing */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(END)
             ENDDO
 
/*/COPY WNCPYSRC,LEC2025MPE                                          */
 
             GOTO       CMDLBL(END)
 
ABNOR:
/*/COPY WNCPYSRC,LEC2025ERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination - batch job */
 
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            LEC2025 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ)
               MONMSG     MSGID(CPF0000 MCH0000)
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/*/COPY WNCPYSRC,LEC2025END                                          */
 
             ENDPGM
