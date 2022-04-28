/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MC Update One Control Group Control')           */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Management Accounts Module                      */
/*                                                                   */
/*       MCC0264 - Update One Control Group Update                   */
/*                                                                   */
/*       Submitted by MCC0260 - Select Control Groups for Update     */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. EML108             Date 14Jan20              */
/*       Prev Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      137075             Date 27Apr99              */
/*                      CED002             Date 19Jun97              */
/*                      CMC001             DATE 28AUG96              */
/*                      057942             DATE 15JUL94              */
/*                      048237             DATE 12MAR93              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*   EML108 - Upgrade FMD003 and fixes to FBM2.1SP21                 */
/*            Add /Copy EML108_003, EML108_004, EML108_005,          */
/*                      EML108_006                                   */
/*   FMD003 - Management Accounts Automatic Balance update           */
/*       MD046248 - Finastra Rebranding                              */
/*   137075 - Ineffective update of Control Group.  Change           */
/*            DTAMBRS from GLHIBLL1 to GLAVBLPD.                     */
/*   CED002 - Midas ED Enhancements                                  */
/*   CMC001 - Management Accounts Enhancement for PCA:               */
/*            Exclusively allocate DTAARA/MC0220.                    */
/*   057942 - If the physical/logical file members for the control   */
/*            group do not exist, add them, else the default of      */
/*            MBR(*FIRST) will be used and the data for this member  */
/*            will be corrupted.                                     */
/*   048237 - Speed up Management Accounts                           */
/*                                                                   */
/*********************************************************************/

             PGM        PARM(&GROUPCODE)

             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
                          /* Copyright statement */
             DCL        VAR(&GROUPCODE) TYPE(*CHAR) LEN(2) /*Group +
                          Code*/
             DCL        VAR(&PERIODSET) TYPE(*CHAR) LEN(1) +
                          /*Period Set*/
             DCL        VAR(&POSTINGBAS) TYPE(*CHAR) LEN(1) +
                          /*Posting Basis*/
             DCL        VAR(&STARTDATE) TYPE(*CHAR) LEN(5) /*Start +
                          Date*/
             DCL        VAR(&SECTIONS) TYPE(*CHAR) LEN(8) /*Sections*/
             DCL        VAR(&ANALYSIS) TYPE(*CHAR) LEN(10) /*Analysis*/
             DCL        VAR(&STARTTIME) TYPE(*CHAR) LEN(6) /*Start +
                          Time*/
             DCL        VAR(&RETURNCODE) TYPE(*CHAR) LEN(1) /*Return +
                          Code*/
             DCL        VAR(&CMC001) TYPE(*CHAR) LEN(1) VALUE('N')    /*CMC001*/
             DCL        VAR(&RTCD)  TYPE(*CHAR) LEN(7) VALUE(' ')     /*CMC001*/
             DCL        VAR(&DSFDY) TYPE(*CHAR) LEN(200)              /*CMC001*/
/************DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2) /* System  */ /*057942*/
/************DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(10)/* xxDPLIB */ /*057942*/
/*/COPY WNCPYSRC,EML108_003                                          */                   /*EML108*/

/* Global error message                                              */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ERROR))

             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/**/
/* Create LDA if it does not already exist */
/**/
             CHKOBJ     OBJ(LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                          DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(' ') TEXT('Midas SD AS400 LOCAL +
                          DATA AREA EQUIVALENT'))
/* */                                                                 /*CMC001*/
/*  Check if Management Accounts Enhancement is installed.         */ /*CMC001*/
/* */                                                                 /*CMC001*/
             CALL       PGM(AOSARDR0) PARM(&RTCD '*VERIFY' 'CMC001' +
                          &DSFDY)                                     /*CMC001*/
/* */                                                                 /*CMC001*/
/*  If Management Accounts Enhancement is installed, exclusively   */ /*CMC001*/
/*  allocate DTAARA/MC0220 to indicate that mgmt a/cs are in use   */ /*CMC001*/
/* */                                                                 /*CMC001*/
             IF         COND(&RTCD *EQ ' ') THEN(DO)                  /*CMC001*/
                CHGVAR     VAR(&CMC001) VALUE('Y')                    /*CMC001*/
                ALCOBJ     OBJ((MC0220 *DTAARA *EXCLRD)) WAIT(0)      /*CMC001*/
                MONMSG     MSGID(CPF1002) EXEC(DO)                    /*CMC001*/
                   SNDPGMMSG  MSG('Management accounts files cannot +
                                allocated at this time.') +
                                TOMSGQ(MOPERQ MRUNQ)                  /*CMC001*/
                   MONMSG     MSGID(CPF0000 RPG0000 MCH0000)          /*CMC001*/
                   GOTO       CMDLBL(ERROR)                           /*CMC001*/
                ENDDO                                                 /*CMC001*/
             ENDDO                                                    /*CMC001*/
/*/COPY WNCPYSRC,EML108_004                                          */                   /*EML108*/

/***Create*GLPOSTL5X*if*it*does*not*exist*to*speedup*OPNQRYF          /*048237*/
/***********                                                          /*048237*/
/*********** RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)           /*048237*/
/*********** CHGVAR     VAR(&DPLIB) VALUE(&SYSID *TCAT 'DPLIB')       /*048237*/
/*********** CHKOBJ     OBJ(&DPLIB/GLPOSTL5X) OBJTYPE(*FILE)          /*048237*/
/*********** MONMSG     MSGID(CPF9801) EXEC(CPYF FROMFILE(GLPOSTL5) + /*048237*/
/***********              TOFILE(&DPLIB/GLPOSTL5X) MBROPT(*ADD) +     /*048237*/
/***********              CRTFILE(*YES))                              /*048237*/

/* Call the Update Control Group program                             */
/* Note that only &GROUPCODE is passed in as non blank, all the      */
/* rest are filled by MC0264                                         */
             CALL       PGM(MC0264) PARM(&GROUPCODE &PERIODSET +
                          &POSTINGBAS &STARTDATE &SECTIONS +
                          &ANALYSIS &STARTTIME)

/* Check no database error                                           */
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
/* */                                                                /*057942*/
/** If the required members do not exist, create them.            */ /*057942*/
/** This will be required where a database is restored containing */ /*057942*/
/** control groups for which the pf/lf members do not exist.      */ /*057942*/
/* */                                                                /*057942*/
             CHKOBJ     OBJ(GLHIBLPD) OBJTYPE(*FILE) MBR(&GROUPCODE) /*057942*/
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(GLHIBLPD) +
                        MBR(&GROUPCODE))                             /*057942*/
/* */                                                                /*057942*/
             CHKOBJ     OBJ(GLHIBLL0) OBJTYPE(*FILE) MBR(&GROUPCODE) /*057942*/
             MONMSG     MSGID(CPF9815) EXEC(ADDLFM FILE(GLHIBLL0) +
                        MBR(&GROUPCODE) DTAMBRS((GLHIBLPD +
                        (&GROUPCODE))))                              /*057942*/
/* */                                                                /*057942*/
             CHKOBJ     OBJ(GLHIBLL3) OBJTYPE(*FILE) MBR(&GROUPCODE) /*057942*/
             MONMSG     MSGID(CPF9815) EXEC(ADDLFM FILE(GLHIBLL3) +
                        MBR(&GROUPCODE) DTAMBRS((GLHIBLPD +
                        (&GROUPCODE))))                              /*057942*/
/* */                                                                /*057942*/
             CHKOBJ     OBJ(GLHIBLL4) OBJTYPE(*FILE) MBR(&GROUPCODE) /*057942*/
             MONMSG     MSGID(CPF9815) EXEC(ADDLFM FILE(GLHIBLL4) +
                        MBR(&GROUPCODE) DTAMBRS((GLHIBLPD +
                        (&GROUPCODE))))                              /*057942*/
/* */                                                                /*057942*/
             CHKOBJ     OBJ(GLAVBLPD) OBJTYPE(*FILE) MBR(&GROUPCODE) /*057942*/
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(GLAVBLPD) +
                        MBR(&GROUPCODE))                             /*057942*/
/* */                                                                /*057942*/
             CHKOBJ     OBJ(GLAVBLL0) OBJTYPE(*FILE) MBR(&GROUPCODE) /*057942*/
             MONMSG     MSGID(CPF9815) EXEC(ADDLFM FILE(GLAVBLL0) +
                        MBR(&GROUPCODE) DTAMBRS((GLAVBLPD +
                        (&GROUPCODE))))                              /*057942*/
/* */                                                                /*057942*/
             CHKOBJ     OBJ(GLAVBLL1) OBJTYPE(*FILE) MBR(&GROUPCODE) /*057942*/
             MONMSG     MSGID(CPF9815) EXEC(ADDLFM FILE(GLAVBLL1) +
                        MBR(&GROUPCODE) DTAMBRS((GLAVBLPD +
                        (&GROUPCODE))))                              /*057942*/
/* */                                                                /*057942*/
             CHKOBJ     OBJ(GLAVBLL3) OBJTYPE(*FILE) MBR(&GROUPCODE) /*057942*/
             MONMSG     MSGID(CPF9815) EXEC(ADDLFM FILE(GLAVBLL3) +
                        MBR(&GROUPCODE) DTAMBRS((GLAVBLPD +
                        (&GROUPCODE))))                              /*057942*/
/* */                                                                /*CED002*/
/*********** CHKOBJ     OBJ(GLHIBLL1) OBJTYPE(*FILE) MBR(&/*CED002*/ /*137075*/
/*********** MONMSG     MSGID(CPF9815) EXEC(ADDLFM FILE(GLHIBLL1) +
/***********            MBR(&GROUPCODE) DTAMBRS((GLHIBLL1 +
/***********            (&GROUPCODE))))                   /*CED002*/ /*137075*/
/* */                                                                /*CED002*/
             CHKOBJ     OBJ(GLHIBLL1) OBJTYPE(*FILE) MBR(&GROUPCODE) /*137075*/
             MONMSG     MSGID(CPF9815) EXEC(ADDLFM FILE(GLHIBLL1) +
                        MBR(&GROUPCODE) DTAMBRS((GLHIBLPD +
                        (&GROUPCODE))))                              /*137075*/
/* */                                                                /*137075*/
/* Override to member for the Group Code                             */
             OVRDBF     FILE(GLHIBLPD) TOFILE(*FILE) MBR(&GROUPCODE)
             OVRDBF     FILE(GLHIBLL0) TOFILE(*FILE) MBR(&GROUPCODE)
             OVRDBF     FILE(GLHIBLL3) TOFILE(*FILE) MBR(&GROUPCODE)
             OVRDBF     FILE(GLHIBLL4) TOFILE(*FILE) MBR(&GROUPCODE)
                                                                     /*CED002*/
             OVRDBF     FILE(GLHIBLL1) TOFILE(*FILE) MBR(&GROUPCODE) /*CED002*/
                                                                     /*CED002*/

             OVRDBF     FILE(GLAVBLPD) TOFILE(*FILE) MBR(&GROUPCODE)
             OVRDBF     FILE(GLAVBLL0) TOFILE(*FILE) MBR(&GROUPCODE)
             OVRDBF     FILE(GLAVBLL1) TOFILE(*FILE) MBR(&GROUPCODE)
             OVRDBF     FILE(GLAVBLL3) TOFILE(*FILE) MBR(&GROUPCODE)
/*********** OVRDBF     FILE(UPDBALPD) TOFILE(GLPOSTL5X) SHARE(*YES)  /*048237*/

/* Call Select Postings using OPNQRYF program                        */
/* These parameters are output by MC0264                             */
/*/COPY WNCPYSRC,EML108_005                                          */                   /*EML108*/
             CALL       PGM(MCC0299) PARM(&PERIODSET &POSTINGBAS +
                          &STARTDATE &SECTIONS &ANALYSIS 'N' +
                          &STARTTIME)
/*/COPY WNCPYSRC,EML108_006                                          */                   /*EML108*/

/* Call Update Management Accounts to Current End of Period program  */
             CALL       PGM(MC0230) PARM(&GROUPCODE &RETURNCODE)

/* Check for database error                                          */
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))

/* Call Update Management Accounts with Movements program            */
/*      Override UPDBALPD to OPNQRYF generated by MCC0299             /*048237*/
             OVRDBF     FILE(UPDBALPD) TOFILE(GLPERDPD) SHARE(*YES)   /*048237*/
             CALL       PGM(MC0235) PARM(&GROUPCODE &RETURNCODE)
             DLTOVR     FILE(UPDBALPD)                                /*048237*/

/* Check for database error                                          */
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))

/* Call Rework DR/CR Average Balances program                        */
             CALL       PGM(MCC0240) PARM(&GROUPCODE &RETURNCODE)

/* Check for database error                                          */
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))

/* ENDDO for processing run if MC0264 does not give a database error */
             ENDDO

/* Delete all file overrides                                         */
             DLTOVR     FILE(*ALL)

             IF         COND(&CMC001 *EQ 'Y') THEN(DO)                /*CMC001*/
                DLCOBJ     OBJ((MC0220 *DTAARA *EXCLRD))              /*CMC001*/
             ENDDO                                                    /*CMC001*/
/* */                                                                 /*CMC001*/
             GOTO       CMDLBL(ENDPGM)

 ERROR:      SNDPGMMSG  MSG('Update One Control Group ENDED +
                          ABNORMALLY') TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)

ENDPGM:      ENDPGM
