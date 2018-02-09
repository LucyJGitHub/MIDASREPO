/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL Maturing fiduciary deposit report')          */
/*********************************************************************/
/*                                                                   */
/*       Midas - Dealing Module                                      */
/*                                                                   */
/*       DLC2101  - Maturing Fiduciary Deposits by Account Officer   */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.01 ---------------------------------------------------*/
/*       Prev Amend No. CDL006  *CREATE    Date 26Apr99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CDL006 - Dealing Fiduciary.                                 */
/*                                                                   */
/*********************************************************************/
             PGM PARM(&RSEQ &RLEV &RENT)
 
/* Declare variables                                               */
 
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* RCF Sequence Number                                             */
 
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
 
/* RCF Level Flag                                                  */
 
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
 
/* RCF Entity Code (All/Comp/Bch)                                  */
 
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&QRYSLT) TYPE(*CHAR) LEN(256)
 
/* Global monitor message                                          */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Send program message                                            */
 
             SNDPGMMSG  MSG('DLC2101 - Maturing Fiduciary Deposits +
                          by Account Officer') TOMSGQ(MRUNQ) +
                          MSGTYPE(*INFO)
 
             CHGJOB     SWS(XXXXXX00)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             RTVJOBA    TYPE(&JOBTYPE)
 
/* Select records                                                  */
 
             CHGVAR     VAR(&QRYSLT) VALUE(' DTYP *EQ %VALUES("FT" +
                          "DT" "LT") *AND ETYP *EQ "16M1" ')
 
             OVRDBF     FILE(DLDTEVPD) TOFILE(EVNTXED) SHARE(*YES)
 
             OPNQRYF    FILE((EVNTXED) (SDCUSTPD)) FORMAT(DLDTEVPD) +
                          QRYSLT(&QRYSLT) KEYFLD((BBACOC) (BBBRCD) +
                          (BBCUST) (DLNO)) JFLD((CUNR BBCUST))
 
/* Call program                                                    */
 
             CALL DL2101 PARM(&RSEQ &RLEV &RENT)
 
             DLTOVR     FILE(DLDTEVPD)
             CLOF       OPNID(EVNTXED)
 
/* Database error processing                                       */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(END)
             ENDDO
 
             GOTO       CMDLBL(END)
 
/* Abnormal termination - batch job                                */
 
 ABNOR:      CHGJOB     SWS(XXXXXX11)
             DMPCLPGM
             IF         COND(&JOBTYPE = '0') THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            DLC2101 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ)
               MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
