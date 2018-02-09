/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('GL Balances in Cons. Euro Ccy by Company')            */
/*********************************************************************/
/*                                                                   */
/*       Midas - Genearl Ledger Module                               */
/*                                                                   */
/*       CLP/GLC66E- GL Balances in Consolidated Euro Ccy by Company */
/*                   on individual account                           */
/*                                                                   */
/*       Function: To Generate the Consolidated Euro Position Report.*/
/*                                                                   */
/*       Called By: GLC0740 - GL Balances in one Ccy; indi. A/C level*/
/*                                                                   */
/*       Calls  :   GL0740 - GL Balances Report by individual account*/
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CEU011  *CREATE    Date 11Mar98              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CEU011 - EMU Position/Risk Reporting                        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTYP &RSEQ &RENT)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)
             DCL        VAR(&RTYP) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
/*/COPY WNCPYSRC,GLC66E001                                           */
 
/** Global monitor message */
 
             MONMSG   MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                        CMDLBL(ABNOR))
 
/* Create LDA if not present */
 
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
               CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                AUT(*EXCLUDE)
             ENDDO
 
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB   SWS(10001X00)
 
             SNDPGMMSG  MSG('GLC66E- GL Balances in Cons. Euro Ccy  +
                          by company  at Indiv. A/c Level') +
                          TOMSGQ(MRUNQ)
 
/** Extract records to the PF/GLEXTRPD */
 
             OVRDBF     FILE(GLEXTRPD) SHARE(*NO)
             MONMSG     MSGID(CPF0000)
             OPNQRYF    FILE((GLEXGC) (SDCURRPD)) FORMAT(GLEXTRPD) +
                          KEYFLD((*MAPFLD/ECSS *ASCEND) (GLEXGC/CCY)) +
                          JFLD((GLEXGC/CCY SDCURRPD/A6CYCD)) +
                          MAPFLD((ECSS A6SSNB) (INCY A6INCY))
             CPYFRMQRYF FROMOPNID(GLEXGC) TOFILE(GLEXTRPD) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2909)
             CLOF       OPNID(GLEXGC)
             DLTOVR     FILE(GLEXTRPD)
             MONMSG     MSGID(CPF0000)
 
             IF         COND((&RENT *NE ' ') *AND (&RENT *NE 'ALL')) +
                        THEN(DO)
                OVRDBF     FILE(GLEXTRL1) POSITION(*KEY 1 GLEXTRD0 +
                           &RENT)
                OPNDBF     FILE(GLEXTRL1) OPTION(*ALL)
                MONMSG     MSGID(CPF0000) EXEC(DO)
                DLTOVR     FILE(GLEXTRL1)
                ENDDO
              ENDDO
 
             OVRDBF     FILE(SGLEX) TOFILE(GLEXTRL1) SHARE(*NO)
             MONMSG     MSGID(CPF0000)
 
/*/COPY WNCPYSRC,GLC66E002                                           */
             CALL       PGM(GL0740) PARM(&RTYP &RSEQ &RENT)
 
/*/COPY WNCPYSRC,GLC66E003                                           */
             DLTOVR     FILE(SGLEX)
             MONMSG     MSGID(CPF0000)
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))
 
             IF         COND(%SWITCH(XXXXXX01)) THEN(SNDPGMMSG +
                          MSG('File Out Of Balance - SGLEX') +
                          TOMSGQ(MOPERQ MRUNQ))
 
             GOTO       CMDLBL(END)
 
ABNOR:       RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
             CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
             SNDPGMMSG  MSG('GLC66E Ended abnormally') TOMSGQ(MOPERQ +
                          MRUNQ)
             MONMSG        MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
