/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Corporate action details audit report')      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Securities Trading Module                           */
/*                                                                   */
/*       CL/SEC7533 - Corporate Actions Details Audit Report         */
/*                                                                   */
/*       Function:                                                   */
/*                                                                   */
/*       Calls :   SE7533 - Corporate Action Details Report Program  */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No.  CSE007 *CREATE    Date  1Dec97              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CSE007 - Corporate Actions                                  */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MODE &RSEQ &RLEV &RENT &PARM)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&MEM)   TYPE(*CHAR) LEN(50)
             DCL        VAR(&MODE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&RSEQ)  TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT)  TYPE(*CHAR) LEN(3)
             DCL        VAR(&PARM)  TYPE(*CHAR) LEN(100)
             DCL        VAR(&EXPR1) TYPE(*CHAR) LEN(55) +
                          VALUE('MACOAT = ''  ''')
             DCL        VAR(&EXPR2) TYPE(*CHAR) LEN(55) +
                          VALUE('MALCD = BJRDNB *AND MACOAT = ''  ''')
             DCL        VAR(&EXPR3) TYPE(*CHAR) LEN(55) +
                          VALUE('MALCD = BJRDNB')
             DCL        VAR(&EXPR4) TYPE(*CHAR) LEN(55) +
                          VALUE('MASTAT = '' ''')
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(30) +
                          VALUE('*AND MASTAT = '' ''')
             DCL        VAR(&REFR) TYPE(*CHAR) LEN(6)
             DCL        VAR(&CAST) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ALCA) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DVEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FRAL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RGIS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CACH) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CORG) TYPE(*CHAR) LEN(1)
             DCL        VAR(&OFFR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&EXRC) TYPE(*CHAR) LEN(1)
             DCL        VAR(&NFEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&NMCH) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CUCH) TYPE(*CHAR) LEN(1)
/*/COPY WNCPYSRC,SEC7533001                                          */
 
/** Global monitor message */
 
             MONMSG   MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                        CMDLBL(ABNOR))
 
/* Create LDA if not present */
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          AUT(*EXCLUDE)
             ENDDO
 
             CHGJOB   SWS(00000000)
/*/COPY WNCPYSRC,SEC7533002                                          */
             CHGVAR   VAR(&REFR)    VALUE(%SST(&PARM 1 6))
             CHGVAR   VAR(&CAST)    VALUE(%SST(&PARM 7 1))
             CHGVAR   VAR(&ALCA)    VALUE(%SST(&PARM 8 1))
             CHGVAR   VAR(&DVEV)    VALUE(%SST(&PARM 9 1))
             CHGVAR   VAR(&FRAL)    VALUE(%SST(&PARM 10 1))
             CHGVAR   VAR(&RGIS)    VALUE(%SST(&PARM 11 1))
             CHGVAR   VAR(&CACH)    VALUE(%SST(&PARM 12 1))
             CHGVAR   VAR(&CORG)    VALUE(%SST(&PARM 13 1))
             CHGVAR   VAR(&OFFR)    VALUE(%SST(&PARM 14 1))
             CHGVAR   VAR(&EXRC)    VALUE(%SST(&PARM 15 1))
             CHGVAR   VAR(&NFEV)    VALUE(%SST(&PARM 16 1))
             CHGVAR   VAR(&NMCH)    VALUE(%SST(&PARM 17 1))
             CHGVAR   VAR(&CUCH)    VALUE(%SST(&PARM 18 1))
/*/COPY WNCPYSRC,SEC7533003                                          */
 
             IF COND(&MODE *EQ '2') THEN(GOTO CMDLBL(FULLIST))
             ELSE GOTO CMDLBL(AUDLIST)
 
/** Full list processing */
/** Select Reference with Status = 'C' and Type = 'DV'*/
/** Dividend Events records*/
 
FULLIST:
             IF COND(&ALCA *EQ 'Y' *AND &CAST *NE ' ') THEN(DO)
               CHGVAR VAR(%SST(&EXPR4 11 1)) VALUE(&CAST)
               OVRDBF FILE(SECORFL1) TOFILE(SECORFL1)
               OPNQRYF FILE((SECORFL1) (SDBANKPD)) OPTION(*INP) +
                 FORMAT(SECORFL1) QRYSLT(&EXPR4) KEYFLD(*FILE)
             ENDDO
 
             IF COND(&CAST *NE ' ') THEN(DO)
               CHGVAR VAR(&EXPR1) VALUE(&EXPR1 *BCAT &STAT)
               CHGVAR VAR(%SST(&EXPR1 30 1)) VALUE(&CAST)
             ENDDO
 
             IF COND(&DVEV *EQ 'Y') THEN(DO)
               CHGVAR  VAR(%SST(&EXPR1 11 2)) VALUE('DV')
               OVRDBF  FILE(SECORFL1) TOFILE(SECORFL1)
               OPNQRYF FILE(SECORFL1) OPTION(*INP) +
                 QRYSLT(&EXPR1) KEYFLD(*FILE)
             ENDDO
 
/** Select Reference with Status = 'C' and Type = 'FR'*/
/** Free Allocation records*/
 
             IF COND(&FRAL *EQ 'Y') THEN(DO)
               CHGVAR   VAR(%SST(&EXPR1 11 2)) VALUE('FR')
               OVRDBF   FILE(SECORFL1) TOFILE(SECORFL1)
               OPNQRYF  FILE(SECORFL1) OPTION(*INP) +
                 QRYSLT(&EXPR1) KEYFLD(*FILE)
             ENDDO
 
/** Select Reference with Status = 'C' and Type = 'RG'*/
/** Right Issues records*/
 
             IF COND(&RGIS *EQ 'Y') THEN(DO)
               CHGVAR   VAR(%SST(&EXPR1 11 2)) VALUE('RG')
               OVRDBF     FILE(SECORFL1) TOFILE(SECORFL1)
               OPNQRYF  FILE(SECORFL1) OPTION(*INP) +
                 QRYSLT(&EXPR1) KEYFLD(*FILE)
             ENDDO
 
/** Select Reference with Status = 'C' and Type = 'CE'*/
/** Capital Changes records*/
 
             IF COND(&CACH *EQ 'Y') THEN(DO)
               CHGVAR   VAR(%SST(&EXPR1 11 2)) VALUE('CE')
               OVRDBF   FILE(SECORFL1) TOFILE(SECORFL1)
               OPNQRYF  FILE(SECORFL1) OPTION(*INP) +
                 QRYSLT(&EXPR1) KEYFLD(*FILE)
             ENDDO
 
/** Select Reference with Status = 'C' and Type = 'CR'*/
/** Corporate Reorganisation records*/
 
             IF COND(&CORG *EQ 'Y') THEN(DO)
               CHGVAR   VAR(%SST(&EXPR1 11 2)) VALUE('CR')
               OVRDBF   FILE(SECORFL1) TOFILE(SECORFL1)
               OPNQRYF  FILE(SECORFL1) OPTION(*INP) +
                 QRYSLT(&EXPR1) KEYFLD(*FILE)
             ENDDO
 
/** Select Reference with Status = 'C' and Type = 'OF'*/
/** Corporate Action Offers records*/
 
             IF COND(&OFFR *EQ 'Y') THEN(DO)
               CHGVAR   VAR(%SST(&EXPR1 11 2)) VALUE('OF')
               OVRDBF   FILE(SECORFL1) TOFILE(SECORFL1)
               OPNQRYF  FILE(SECORFL1) OPTION(*INP) +
                 QRYSLT(&EXPR1) KEYFLD(*FILE)
             ENDDO
 
/** Select Reference with Status = 'C' and Type = 'EX'*/
/** Corporate Action Exercises records */
 
             IF COND(&EXRC *EQ 'Y') THEN(DO)
               CHGVAR   VAR(%SST(&EXPR1 11 2)) VALUE('EX')
               OVRDBF   FILE(SECORFL1) TOFILE(SECORFL1)
               OPNQRYF  FILE(SECORFL1) OPTION(*INP) +
                 QRYSLT(&EXPR1) KEYFLD(*FILE)
             ENDDO
 
/** Select Reference with Status = 'C' and Type = 'NF'*/
/** Corporate Action Non Financial Events*/
 
             IF COND(&NFEV *EQ 'Y') THEN(DO)
               CHGVAR   VAR(%SST(&EXPR1 11 2)) VALUE('NF')
               OVRDBF   FILE(SECORFL1) TOFILE(SECORFL1)
               OPNQRYF  FILE(SECORFL1) OPTION(*INP) +
                 QRYSLT(&EXPR1) KEYFLD(*FILE)
             ENDDO
 
/** Select Reference with Status = 'C' and Type = 'NC'*/
/** Corporate Action Name Changes*/
 
             IF COND(&NMCH *EQ 'Y') THEN(DO)
               CHGVAR   VAR(%SST(&EXPR1 11 2)) VALUE('NC')
               OVRDBF   FILE(SECORFL1) TOFILE(SECORFL1)
               OPNQRYF  FILE(SECORFL1) OPTION(*INP) +
                 QRYSLT(&EXPR1) KEYFLD(*FILE)
             ENDDO
 
/** Select Reference with Status = 'C' and Type = 'CC'*/
/** Corporate Action Currency Changes*/
 
             IF COND(&CUCH *EQ 'Y') THEN(DO)
               CHGVAR   VAR(%SST(&EXPR1 11 2)) VALUE('CC')
               OVRDBF   FILE(SECORFL1) TOFILE(SECORFL1)
               OPNQRYF  FILE(SECORFL1) OPTION(*INP) +
                 QRYSLT(&EXPR1) KEYFLD(*FILE)
             ENDDO
/*/COPY WNCPYSRC,SEC7533004                                          */
             GOTO CMDLBL(CONT)
AUDLIST:
 
/** Select Reference with Status = 'C' */
/** All Corporate Actions  */
 
             IF COND(&ALCA *EQ 'Y') THEN(DO)
               IF COND(&CAST *NE ' ') THEN(DO)
                 CHGVAR VAR(&EXPR3) VALUE(&EXPR3 *BCAT &STAT)
                 CHGVAR VAR(%SST(&EXPR3 31 1)) VALUE(&CAST)
               ENDDO
               OVRDBF   FILE(SECORFL1) TOFILE(SECORFL1)
               OPNQRYF  FILE((SECORFL1) (SDBANKPD)) OPTION(*INP) +
                 FORMAT(SECORFL1) QRYSLT(&EXPR3) KEYFLD(*FILE)
             ENDDO
 
             IF COND(&CAST *NE ' ') THEN(DO)
               CHGVAR VAR(&EXPR2) VALUE(&EXPR2 *BCAT &STAT)
               CHGVAR VAR(%SST(&EXPR2 50 1)) VALUE(&CAST)
             ENDDO
 
/** Select Reference with Status = 'C' and Type = 'DV'*/
/** Dividend Events records*/
 
             IF COND(&DVEV *EQ 'Y') THEN(DO)
               CHGVAR   VAR(%SST(&EXPR2 31 2)) VALUE('DV')
               OVRDBF   FILE(SECORFL1) TOFILE(SECORFL1)
               OPNQRYF  FILE((SECORFL1) (SDBANKPD)) OPTION(*INP) +
                 FORMAT(SECORFL1) QRYSLT(&EXPR2) KEYFLD(*FILE)
             ENDDO
 
/** Select Reference with Status = 'C' and Type = 'FR'*/
/** Free Allocation records*/
 
             IF COND(&FRAL *EQ 'Y') THEN(DO)
               CHGVAR   VAR(%SST(&EXPR2 31 2)) VALUE('FR')
               OVRDBF   FILE(SECORFL1) TOFILE(SECORFL1)
               OPNQRYF  FILE((SECORFL1) (SDBANKPD)) OPTION(*INP) +
                 FORMAT(SECORFL1) QRYSLT(&EXPR2) KEYFLD(*FILE)
             ENDDO
 
/** Select Reference with Status = 'C' and Type = 'RG'*/
/** Right Issues records*/
 
             IF COND(&RGIS *EQ 'Y') THEN(DO)
               CHGVAR   VAR(%SST(&EXPR2 31 2)) VALUE('RG')
               OVRDBF   FILE(SECORFL1) TOFILE(SECORFL1)
               OPNQRYF  FILE((SECORFL1) (SDBANKPD)) OPTION(*INP) +
                 FORMAT(SECORFL1) QRYSLT(&EXPR2) KEYFLD(*FILE)
             ENDDO
 
/** Select Reference with Status = 'C' and Type = 'CE'*/
/** Capital Changes records*/
 
             IF COND(&CACH *EQ 'Y') THEN(DO)
               CHGVAR   VAR(%SST(&EXPR2 31 2)) VALUE('CE')
               OVRDBF   FILE(SECORFL1) TOFILE(SECORFL1)
               OPNQRYF  FILE((SECORFL1) (SDBANKPD)) OPTION(*INP) +
                 FORMAT(SECORFL1) QRYSLT(&EXPR2) KEYFLD(*FILE)
             ENDDO
 
/** Select Reference with Status = 'C' and Type = 'CR'*/
/** Corporate Reorganisation records*/
 
             IF COND(&CORG *EQ 'Y') THEN(DO)
               CHGVAR   VAR(%SST(&EXPR2 31 2)) VALUE('CR')
               OVRDBF   FILE(SECORFL1) TOFILE(SECORFL1)
               OPNQRYF  FILE((SECORFL1) (SDBANKPD)) OPTION(*INP) +
                 FORMAT(SECORFL1) QRYSLT(&EXPR2) KEYFLD(*FILE)
             ENDDO
 
/** Select Reference with Status = 'C' and Type = 'OF'*/
/** Corporate Action Offers records*/
 
             IF COND(&OFFR *EQ 'Y') THEN(DO)
               CHGVAR   VAR(%SST(&EXPR2 31 2)) VALUE('OF')
               OVRDBF   FILE(SECORFL1) TOFILE(SECORFL1)
               OPNQRYF  FILE((SECORFL1) (SDBANKPD)) OPTION(*INP) +
                 FORMAT(SECORFL1) QRYSLT(&EXPR2) KEYFLD(*FILE)
             ENDDO
 
/** Select Reference with Status = 'C' and Type = 'EX'*/
/** Corporate Action Exercises records*/
 
             IF COND(&EXRC *EQ 'Y') THEN(DO)
               CHGVAR   VAR(%SST(&EXPR2 31 2)) VALUE('EX')
               OVRDBF   FILE(SECORFL1) TOFILE(SECORFL1)
               OPNQRYF  FILE((SECORFL1) (SDBANKPD)) OPTION(*INP) +
                 FORMAT(SECORFL1) QRYSLT(&EXPR2) KEYFLD(*FILE)
             ENDDO
 
/** Select Reference with Status = 'C' and Type = 'NF'*/
/** Corporate Action Non Financial Events*/
 
             IF COND(&NFEV *EQ 'Y') THEN(DO)
               CHGVAR   VAR(%SST(&EXPR2 31 2)) VALUE('NF')
               OVRDBF   FILE(SECORFL1) TOFILE(SECORFL1)
               OPNQRYF  FILE((SECORFL1) (SDBANKPD)) OPTION(*INP) +
                 FORMAT(SECORFL1) QRYSLT(&EXPR2) KEYFLD(*FILE)
             ENDDO
 
/** Select Reference with Status = 'C' and Type = 'NC'*/
/** Corporate Action Name Changes*/
 
             IF COND(&NMCH *EQ 'Y') THEN(DO)
               CHGVAR   VAR(%SST(&EXPR2 31 2)) VALUE('NC')
               OVRDBF   FILE(SECORFL1) TOFILE(SECORFL1)
               OPNQRYF  FILE((SECORFL1) (SDBANKPD)) OPTION(*INP) +
                 FORMAT(SECORFL1) QRYSLT(&EXPR2) KEYFLD(*FILE)
             ENDDO
 
/** Select Reference with Status = 'C' and Type = 'CC'*/
/** Corporate Action Currency Changes*/
 
             IF COND(&CUCH *EQ 'Y') THEN(DO)
               CHGVAR   VAR(%SST(&EXPR2 31 2)) VALUE('CC')
               OVRDBF     FILE(SECORFL1) TOFILE(SECORFL1)
               OPNQRYF  FILE((SECORFL1) (SDBANKPD)) OPTION(*INP) +
                 FORMAT(SECORFL1) QRYSLT(&EXPR2) KEYFLD(*FILE)
             ENDDO
/*/COPY WNCPYSRC,SEC7533005                                          */
 
CONT:        CALL PGM(SE7533) PARM(&RSEQ &RLEV &RENT &MODE &PARM)
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                GOTO       CMDLBL(ABNOR)
             ENDDO
             GOTO       CMDLBL(END)
 
ABNOR:       RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
               TOMSGQ(MOPERQ MRUNQ)
             CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSG('SEC7533 ENDED ABNORMALLY') +
               TOMSGQ(MOPERQ MRUNQ)
             MONMSG        MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             CLOF          OPNID(SECORFL1)
             MONMSG        MSGID(CPF0000 MCH0000)
             DLTOVR        FILE(*ALL)
             MONMSG        MSGID(CPF0000 MCH0000)
             ENDPGM
