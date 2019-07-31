/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Corporate Action Types Audit/List')          */
/*********************************************************************/
/*                                                                   */
/*       Midas - Securities Trading Module                           */
/*                                                                   */
/*       SEC7530 - Corporate Action Types Audit List                 */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSE007  *CREATE    Date 1DEc97               */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSE007 - Corporate Actions                                  */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MODE &RSEQ &RLEV &RENT)
 
/* Declare variables */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
 
             MONMSG MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO CMDLBL(ABNOR))
 
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
               CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                AUT(*EXCLUDE)
             ENDDO
 
/* Reset external switches */
               CHGJOB     SWS(00000000)
 
               IF         COND(&MODE *EQ '2') THEN(DO)
                 OVRDBF     FILE(SECOATPD) SHARE(*YES)
                 OPNQRYF    FILE((SECOATPD)) QRYSLT('MMRECI *NE ''*''') +
                   KEYFLD(*FILE)
                 CALL       PGM(SE7530) PARM(&MODE &RSEQ)
                 CLOF       OPNID(SECOATPD)
                 DLTOVR     FILE(SECOATPD)
               ENDDO
 
               ELSE       CMD(DO)
                 SNDPGMMSG  MSG('SEC7530 - Corporate Action Types - +
                   Report') TOMSGQ(MRUNQ) MSGTYPE(*INFO)
                 OVRDBF     FILE(SECOATPD) SHARE(*YES)
                 OPNQRYF    FILE((SECOATPD) (SDBANKPD)) +
                   FORMAT(SECOATPD) QRYSLT('MMLCD *EQ BJRDNB') +
                   KEYFLD(*FILE)
                 CALL       PGM(SE7530) PARM(&MODE &RSEQ)
                 CLOF       OPNID(SECOATPD)
                 DLTOVR     FILE(SECOATPD)
               ENDDO
 
/* Error processing */
               IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                   TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
               ENDDO
 
               ELSE       CMD(DO)
                 GOTO       CMDLBL(ENDPGM)
               ENDDO
 
/* Error processing */
 ABNOR:      CHGJOB     SWS(XXXXXX11)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
 
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
