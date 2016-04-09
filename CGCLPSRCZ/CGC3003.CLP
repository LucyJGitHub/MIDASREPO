/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas CG Clone work file into QTEMP')                 */
/*********************************************************************/
/*                                                                   */
/*       Midas     - User Defined Correspondence                     */
/*                                                                   */
/*       CGC3003  - Put *LIFO DTAQ in QTEMP                          */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. CUP006             Date 23Jul10              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. 123630             Date 30Sep97              */
/*                      S01522             Date 01Jan95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CUP006 - Tidying of DTALIB.                                 */
/*       123630 - Add MONMSG to ADDPFM and ADDLFM commands           */
/*       S01522 - User Defined Correspondence                        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTN_CODE &WORKF)
/* */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/* */
             DCL        VAR(&RTN_CODE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&WORKF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIBNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILEATR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PFX) TYPE(*CHAR) LEN(2)                                      /*CUP006*/
             DCL        VAR(&DVLIB) TYPE(*CHAR) LEN(10)                                   /*CUP006*/
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(10)                                   /*CUP006*/
/* */
/* Global Monitor Message */
/* */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
/* */
/* Set switches & remove messages */
/* */
             CHGJOB     SWS(XXXXX000)
             CHGVAR     VAR(&RTN_CODE) VALUE(' ')
/* Ensure QTEMP is at top of library list */
             RMVLIBLE   LIB(QTEMP)
             MONMSG     MSGID(CPF2104)
             ADDLIBLE   LIB(QTEMP)
/* Create File in QTEMP, this will be used as a work file */
             CHKOBJ     OBJ(QTEMP/&WORKF) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(CRT))
             GOTO       CMDLBL(FIL)
/* */
 CRT:        RTVOBJD    OBJ(&WORKF) OBJTYPE(*FILE) RTNLIB(&LIBNAM) +
                          OBJATR(&FILEATR)
             MONMSG     MSGID(CPF9812) EXEC(DO)
             CHGVAR     VAR(&RTN_CODE) VALUE('*ERROR*')
             GOTO       CMDLBL(END)
             ENDDO
 
/* Retrieve system prefix and set up library names. */                                    /*CUP006*/
             CHGVAR     VAR(&PFX) VALUE(%SST(&LIBNAM 1 2))                                /*CUP006*/
             CHGVAR     VAR(&DVLIB) VALUE(&PFX *TCAT 'DVLIB')                             /*CUP006*/
             CHGVAR     VAR(&DPLIB) VALUE(&PFX *TCAT 'DPLIB')                             /*CUP006*/
             IF         COND(&WORKF *EQ 'CGWPLAYO' *OR &WORKF *EQ +
                          'CGWPRDE2') THEN(DO)                                            /*CUP006*/
                IF         COND(&LIBNAM *EQ &DPLIB) THEN(DO)                              /*CUP006*/
                   MOVOBJ     OBJ(&LIBNAM/&WORKF) OBJTYPE(*FILE) +
                                TOLIB(&DVLIB)                                             /*CUP006*/
                ENDDO                                                                     /*CUP006*/
             ENDDO                                                                        /*CUP006*/
                                                                                          /*CUP006*/
/* */
             CRTDUPOBJ  OBJ(&WORKF) FROMLIB(&LIBNAM) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
                                                                                          /*CUP006*/
             IF         COND(&WORKF *EQ 'CGWPLAYO' *OR &WORKF *EQ +
                          'CGWPRDE2') THEN(DO)                                            /*CUP006*/
                MOVOBJ     OBJ(&DVLIB/&WORKF) OBJTYPE(*FILE) TOLIB(&DPLIB)                /*CUP006*/
             ENDDO                                                                        /*CUP006*/
/* */
             IF         COND(&FILEATR = 'PF') THEN(DO)
             ADDPFM     FILE(QTEMP/&WORKF) MBR(&WORKF)
             MONMSG     MSGID(CPF5812 CPF7306)             /*123630*/
             ENDDO
/* */
             IF         COND(&FILEATR = 'LF') THEN(DO)
             ADDLFM     FILE(QTEMP/&WORKF) MBR(&WORKF)
             MONMSG     MSGID(CPF5812 CPF7306)             /*123630*/
             ENDDO
/* */
 FIL:        RTVOBJD    OBJ(QTEMP/&WORKF) OBJTYPE(*FILE) +
                          OBJATR(&FILEATR)
/* */
             IF         COND(&FILEATR = 'PF') THEN(DO)
             CLRPFM     FILE(QTEMP/&WORKF)
             ENDDO
/* */
             GOTO       CMDLBL(ENDCLPGM)
/**/
/* Abnormal termination processing                       */
/**/
ABNORMAL:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program CGC3003 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          CGC3003 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDCLPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/* */
 END:        ENDPGM
