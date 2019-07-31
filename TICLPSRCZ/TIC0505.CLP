/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas TI Count Unposted Deals/Accruals')              */
/*********************************************************************/
/*                                                                   */
/*       Midas - Trade Innovation Module                             */
/*                                                                   */
/*       TIC0505 - Get number of Unposted transactions and number of */
/*                 Accruals in TIPOSTPD                              */
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
/*       Prev Amend No. CTI003  *CREATE    Date 10Nov00              */
/*                      XNNNNN             Date DDMmmYY              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CTI003 - Midas/TI Interface CoB                             */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MODE &NBRRCD)
 
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(8)
             DCL        VAR(&NBRRCD) TYPE(*DEC) LEN(10)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(132)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Create outfile, & change to SIZE(*NOMAX)                            */
             CPYF       FROMFILE(TIPOSTL0) TOFILE(QTEMP/TIPOSTTMP) +
                          MBROPT(*REPLACE) CRTFILE(*YES) NBRRCDS(1)
 /* If from-file member is empty, return to calling program       */
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(DO)
                GOTO       CMDLBL(END)
             ENDDO
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2870) EXEC(DO)
                GOTO       CMDLBL(END)
             ENDDO
 
             CHGPF      FILE(QTEMP/TIPOSTTMP) SIZE(*NOMAX)
             CLRPFM     FILE(QTEMP/TIPOSTTMP)
/* Depending on requester code, get number of records - Unposted,      */
/* Accruals, Unposted accruals.                                        */
             MONMSG     MSGID(CPF0000 MCH0000)
             IF         COND(&MODE *EQ 'Accruals') THEN(GOTO +
                          CMDLBL(ACCRUALS))
             IF         COND(&MODE *EQ 'Pending ') THEN(GOTO +
                          CMDLBL(PENDING))
             IF         COND(&MODE *EQ 'Unposted') THEN(GOTO +
                          CMDLBL(UNPOSTED))
 
/* Get number of Unposted Records. */
 UNPOSTED:
             CPYF       FROMFILE(TIPOSTL0) TOFILE(QTEMP/TIPOSTTMP) +
                          MBROPT(*ADD) INCCHAR(PSTS 1 *EQ PJN)
 /* If no records found, ignore. */
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2870)
 
             CPYF       FROMFILE(TIPOSTL0) TOFILE(QTEMP/TIPOSTTMP) +
                          MBROPT(*ADD) INCCHAR(PSTS 1 *EQ PJS)
 /* If no records found, ignore. */
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2870)
 
 /* Retrieve the number of records in the file. */
             RTVMBRD    FILE(QTEMP/TIPOSTTMP) NBRCURRCD(&NBRRCD)
             GOTO       CMDLBL(END)
 
/* Get number of Accruals. */
ACCRUALS:
             CPYF       FROMFILE(TIPOSTL0) TOFILE(QTEMP/TIPOSTTMP) +
                          MBROPT(*ADD) INCREL((*IF TISEQN *GE 900))
/* If from-file member is empty, return to calling program. */
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(DO)
                GOTO       CMDLBL(END)
             ENDDO
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2870) EXEC(DO)
                GOTO       CMDLBL(END)
             ENDDO
 
 /* Retrieve the number of records in the file. */
             RTVMBRD    FILE(QTEMP/TIPOSTTMP) NBRCURRCD(&NBRRCD)
             GOTO       CMDLBL(END)
 
/* Get number of Unposted Accruals. */
PENDING:
             CPYF       FROMFILE(TIPOSTL0) TOFILE(QTEMP/TIPOSTTMP) +
                          MBROPT(*ADD) INCCHAR(PSTS 1 *NE 'JEG') +
                          INCREL((*IF TISEQN *GE 900))
/* If from-file member is empty, return to calling program       */
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(DO)
                GOTO       CMDLBL(END)
             ENDDO
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2870) EXEC(DO)
                GOTO       CMDLBL(END)
             ENDDO
 
 /* Retrieve the number of records in the file.                  */
             RTVMBRD    FILE(QTEMP/TIPOSTTMP) NBRCURRCD(&NBRRCD)
             GOTO       CMDLBL(END)
 
/* Abnormal termination  */
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             CHGVAR     VAR(&MSG) VALUE('TIC0505 -  +
                          terminated abnormally')
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(&MSG) +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             DLTF       FILE(QTEMP/TIPOSTTMP)
             MONMSG     MSGID(CPF0000 MCH0000)
             ENDPGM
