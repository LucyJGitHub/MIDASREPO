/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CF Confirmation matching i/c termination')      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Confirmation Matching Module                        */
/*                                                                   */
/*       CFC0181 - Confirmation Matching I/c Termination             */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD027509           Date 10Oct22              */
/*       Prev Amend No. CSC059             Date 10Oct22              */
/*                      MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      159195 (147192)    DATE 05Dec06              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CPK024             Date 12Apr06              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      125867             Date 12Nov97              */
/*                      CCB001 *CREATE     Date 01Mar95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD027509 - Change folder calculation to use absolute path.  */
/*                  Applied for MD-38096                             */
/*       CSC059 - Replace QDLS processing by IFS                     */
/*       MD046248 - Finastra Rebranding                              */
/*       159195 - Applied fix 147192.                                */
/*       147192 - Delete TRAM.DAT if still there when COB runs.      */
/*       CPK024 - Packaging of MPlus 1.2.1. Copy sources needed by   */
/*                UTC0012.                                           */
/*       125867 - End CFCONTROL before call to CFC0180 (done in      */
/*                SCC05 in previous releases)                        */
/*       CCB001 - CoB Enhancement (Batch Processing)                 */
/*                                                                   */
/*********************************************************************/
             PGM

/***COPY*CFCPYSRC,CFC0181INT*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,CFC0181INT                                          */                   /*CPK024*/

             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&CFSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&SPLFST) TYPE(*CHAR) LEN(1)
             DCL        VAR(&COUNT) TYPE(*DEC) LEN(1) VALUE(0)
             DCL        VAR(&DLO) TYPE(*CHAR) LEN(3)              /* 147192 */
/*****       DCL        VAR(&FLR) TYPE(*CHAR) LEN(10)             /* 147192 */            /*CSC059*/
             DCL        VAR(&FLR) TYPE(*CHAR) LEN(50)                                     /*CSC059*/
             DCL        VAR(&CNT) TYPE(*DEC) LEN(3) VALUE(0)      /* 147192 */
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(50)                                    /*CSC059*/
             DCL        VAR(&IASP_YN) TYPE(*CHAR) LEN(1)                                  /*CSC059*/
             DCL        VAR(&IASP) TYPE(*CHAR) LEN(10)                                    /*CSC059*/
             DCL        VAR(&ZSUBDIR) TYPE(*CHAR) LEN(200)                                /*CSC059*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*VERIFY')                    /*CSC059*/
             DCL        VAR(&RTNC) TYPE(*CHAR) LEN(7) VALUE('       ')                    /*CSC059*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6) VALUE('CSC059')                      /*CSC059*/
             DCL        VAR(&SARREC) TYPE(*CHAR) LEN(200)                                 /*CSC059*/
             DCL        VAR(&CSC059) TYPE(*CHAR) LEN(1) VALUE('N' )                       /*CSC059*/
/*/COPY GPCPYSRCG,GPSVALDCL                                          */                   /*CSC059*/
             DCL        VAR(&CNT) TYPE(*DEC) LEN(3) VALUE(0)      /* 147192 */

/* Global monitor message */

             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/*                                                                                        /*CSC059*/
/* Check if feature CSC059 is on */                                                       /*CSC059*/
             CALL       PGM(AOSARDR0) PARM(&RTNC &OPTN &SAR &SARREC)                      /*CSC059*/
             IF         COND(&RTNC *EQ '       ') THEN(CHGVAR +
                          VAR(&CSC059) VALUE('Y'))                                        /*CSC059*/
/*                                                                                        /*CSC059*/
/* If CSC059 is on, check IASP */                                                         /*CSC059*/
             IF         COND(&CSC059 *EQ 'Y') THEN(DO)                                    /*CSC059*/
/*  Get the global IASP system values */                                                  /*CSC059*/
/*                                                                                        /*CSC059*/
             CALL       PGM(GPAOSVALR0) PARM(&RSVALRTNC +
                          'IASPinstallation' &SVAL1 'IASPgroup' +
                          &SVAL2 &SVALK3 &SVAL3 &SVALK4 &SVAL4 +
                          &SVALK5 &SVAL5 &SVALK6 &SVAL6 &SVALK7 +
                          &SVAL7 &SVALK8 &SVAL8 &SVALK9 &SVAL9 +
                          &SVALK10 &SVAL10)                                               /*CSC059*/
/*                                                                                          CSC059*/
/** Check whether system is in IASP environment.                                            CSC059*/
/*                                                                                          CSC059*/
             CHGVAR     VAR(&IASP_YN) VALUE(%SST(&SVAL1 1 1))                             /*CSC059*/
/*                                                                                          CSC059*/
/*  If IASP environment,                                                                    CSC059*/
/*                                                                                          CSC059*/
             IF         COND(&IASP_YN *EQ 'Y') THEN(DO)                                   /*CSC059*/
/*                                                                                          CSC059*/
/*  Get name of IASP.                                                                       CSC059*/
/*                                                                                          CSC059*/
             CHGVAR     VAR(&IASP) VALUE(%SST(&SVAL2 1 10))                               /*CSC059*/
             ENDDO                                                                        /*CSC059*/

/*                                                                                        /*CSC059*/
/** Get the zone IFS subdirectory system value */                                         /*CSC059*/
/*                                                                                        /*CSC059*/
             CALL       PGM(AOSVALR0) PARM(&RSVALRTNC +
                          'ZoneIFSsubdirectory' &SVAL1 &SVALK2 +
                          &SVAL2 &SVALK3 &SVAL3 &SVALK4 &SVAL4 +
                          &SVALK5 &SVAL5 &SVALK6 &SVAL6 &SVALK7 +
                          &SVAL7 &SVALK8 &SVAL8 &SVALK9 &SVAL9 +
                          &SVALK10 &SVAL10)                                               /*CSC059*/
/*                                                                                        /*CSC059*/
/** Determine IFS subdirectory. */                                                        /*CSC059*/
/*                                                                                        /*CSC059*/
             CHGVAR     VAR(&ZSUBDIR) VALUE(%SST(&SVAL1 1 200))                           /*CSC059*/
/*                                                                                        /*CSC059*/
             ENDDO                                                                        /*CSC059*/

/***COPY*CFCPYSRC,CFC0181MPS*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,CFC0181MPS                                          */                   /*CPK024*/

/* End CFCONTROL if still active */                                  /*125867*/
             RTVDTAARA  DTAARA(CFSTAT) RTNVAR(&CFSTAT)               /*125867*/
                                                                     /*125867*/
             IF         COND(%SST(&CFSTAT 49 6) *NE '      ') +
                          THEN(CALL PGM(CFCONTEND))                  /*125867*/
             DLYJOB     DLY(10)                                   /* 147192 */
             RTVDTAARA  DTAARA(CFSTAT (1 3)) RTNVAR(&DLO)         /* 147192 */
             IF         COND(&CSC059 *EQ 'Y') THEN(DO)                                    /*CSC059*/
             IF         COND(&IASP_YN *EQ 'Y') THEN(DO)                                   /*CSC059*/
/**********  CHGVAR     VAR(&FLR) VALUE(&IASP *TCAT '/' *CAT +
                          &ZSUBDIR *TCAT '/CFFLR.' *CAT &DLO)                /*CSC059*/ /*MD027509*/
             CHGVAR     VAR(&FLR) VALUE('/' *CAT &IASP *TCAT '/' *CAT +
                          &ZSUBDIR *TCAT '/CFFLR.' *CAT &DLO)                           /*MD027509*/
             ENDDO                                                                        /*CSC059*/
             ELSE       CMD(DO)                                                           /*CSC059*/
             CHGVAR     VAR(&FLR) VALUE('/' *CAT +
                          &ZSUBDIR *TCAT '/CFFLR.' *CAT &DLO)                           /*MD027509*/
             ENDDO                                                                        /*CSC059*/
             ENDDO                                                                        /*CSC059*/
             ELSE       CMD(DO)                                                           /*CSC059*/
             CHGVAR     VAR(&FLR) VALUE('CFFLR.' *CAT &DLO)       /* 147192 */
             CHGVAR     VAR(&CNT) VALUE(0)                        /* 147192 */
             ENDDO                                                                        /*CSC059*/
DELETE:                                                           /* 147192 */
             DLYJOB     DLY(1)                                    /* 147192 */
             CHGVAR     VAR(&CNT) VALUE(&CNT + 1)                 /* 147192 */
                                                                  /* 147192 */
             IF         COND(&CNT *LE 50) THEN(DO)                /* 147192 */
                                                                  /* 147192 */
             IF         COND(&CSC059 *EQ 'Y') THEN(DO)                                    /*CSC059*/
             OVRPRTF FILE(QSYSPRT) HOLD(*YES)                                             /*CSC059*/
             CHGVAR  VAR(&FILE) VALUE(&FLR *TCAT '/TRAM.DAT')                             /*CSC059*/
             DSPLNK     OBJ(&FILE) OUTPUT(*PRINT)                                         /*CSC059*/
             MONMSG (CPFA0A9) EXEC(GOTO CMDLBL(GONE))                                     /*CSC059*/
             DLTSPLF FILE(QSYSPRT) SPLNBR(*LAST)                                          /*CSC059*/
             DLTOVR FILE(QSYSPRT)                                                         /*CSC059*/
                                                                                          /*CSC059*/
                                                                                          /*CSC059*/
             RMVLNK  OBJLNK(&FILE)                                                        /*CSC059*/
             MONMSG (CPF0000)                                                             /*CSC059*/
             GOTO       CMDLBL(DELETE)                            /* 147192 */            /*CSC059*/
                                                                                          /*CSC059*/
             ENDDO                                                                        /*CSC059*/
             ELSE (DO)                                                                    /*CSC059*/
             CHKDLO     DLO(TRAM.DAT) FLR(&FLR) OBJTYPE(*DOC)     /* 147192 */
             MONMSG     MSGID(CPF8A82) EXEC(GOTO CMDLBL(GONE))    /* 147192 */
                                                                  /* 147192 */
             DLTDLO     DLO(TRAM.DAT) FLR(&FLR)                   /* 147192 */
             MONMSG     MSGID(CPF0000)                            /* 147192 */
             GOTO       CMDLBL(DELETE)                            /* 147192 */
             ENDDO                                                                        /*CSC059*/
                                                                  /* 147192 */
             ENDDO                                                /* 147192 */
                                                                  /* 147192 */
GONE:                                                             /* 147192 */
                                                                  /* 147192 */
/**/
/*  If CONFIRMATION MATCHING is present, wait until the I/C run of */
/*  CFC0180 has completed or is in "DELAY" status, then call it    */
/*  interactively                                                  */
/**/
             RTVDTAARA  DTAARA(CFSTAT) RTNVAR(&CFSTAT)

             IF         COND(%SST(&CFSTAT 49 6) *EQ 'ACTIVE') THEN(DO)

 LOOP:          CALL       PGM(CFCHECK)

                RTVDTAARA  DTAARA(QTEMP/SPLFST (1 1)) RTNVAR(&SPLFST)

                DLTF       FILE(QTEMP/SPLF)
                MONMSG     MSGID(CPF0000)

                DLTDTAARA  DTAARA(QTEMP/SPLFST)
                MONMSG     MSGID(CPF0000)

                IF     COND(&SPLFST *EQ 'Y') THEN(DO)
                    IF  COND(&COUNT *LE 3) THEN(DO)
                       DLYJOB     DLY(60)
                       CHGVAR     VAR(&COUNT) VALUE(&COUNT + 1)
                       GOTO       CMDLBL(LOOP)
                    ENDDO
                    ELSE       CMD(DO)
                       SNDPGMMSG  MSG('Midas/TRAM interface program +
                                    termination failed.') +
                                    TOMSGQ(MOPERQ)
                       GOTO       CMDLBL(ABNOR)
                    ENDDO
                ENDDO

                CHGVAR     VAR(%SST(&CFSTAT 49 6)) VALUE('      ')

                CHGDTAARA  DTAARA(CFSTAT) VALUE(&CFSTAT)

             ENDDO

             CALL       PGM(CFC0180)

             IF         COND(%SWITCH(XXXXXXX1)) THEN(GOTO +
                          CMDLBL(ABNOR))

/* End CFCONTROL if still active */                                  /*125867*/
             RTVDTAARA  DTAARA(CFSTAT) RTNVAR(&CFSTAT)               /*125867*/
                                                                     /*125867*/
             IF         COND(%SST(&CFSTAT 49 6) *NE '      ') +
                          THEN(CALL PGM(CFCONTEND))                  /*125867*/
                                                                     /*125867*/
/***COPY*CFCPYSRC,CFC0181MPE*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,CFC0181MPE                                          */                   /*CPK024*/

             GOTO       CMDLBL(END)

 ABNOR:
/***COPY*CFCPYSRC,CFC0181ERR*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,CFC0181ERR                                          */                   /*CPK024*/

             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)

             SNDMSG     MSG('CFC0181 ended abnormally') TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)

 END:

/***COPY*CFCPYSRC,CFC0181END*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,CFC0181END                                          */                   /*CPK024*/

             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')

             ENDPGM
