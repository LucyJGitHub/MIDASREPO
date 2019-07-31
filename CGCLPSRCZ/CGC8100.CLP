/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CG Check layout in use')                        */
/*********************************************************************/
/*                                                                   */
/*       Midas     - User Defined Correspondence                     */
/*                                                                   */
/*       CGC8100  - Check Layout in use                              */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. 219770             Date 06Jun06              */
/*                      BUG6129            Date 11Mar05              */
/*                      CSC022             Date 24Feb04              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CPK015             Date 18Apr02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01522             Date 29Dec94              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       219770 - CPK015 incomplete causing error on read of         */
/*                data queue.                                        */
/*       BUG6129 - Ensure data area is deallocated. Fix is           */
/*                 patterned after 231885.                           */
/*       CSC022 - Commitment Control Changes for MidasPlus           */
/*       CPK015 - 4.01 packaging.  Use DPLIB instead of DILIB.       */
/*       S01522 - User Defined Correspondence                        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTN_CODE &ACTION &KEY_INFO)
/* */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/* */
/* Declare variables */
/* */
             DCL        VAR(&RTN_CODE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&ACTION) TYPE(*CHAR) LEN(10)
             DCL        VAR(&KEY_INFO) TYPE(*CHAR) LEN(100)
             DCL        VAR(&KEY) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ORDER) TYPE(*CHAR) LEN(2)
             DCL        VAR(&SNDR_LEN) TYPE(*DEC) LEN(3 0) VALUE(44)
             DCL        VAR(&SNDR) TYPE(*CHAR) LEN(44)
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBNUM) TYPE(*CHAR) LEN(6)
             DCL        VAR(&DQUEUE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ERR_DATA) TYPE(*CHAR) LEN(50)
             DCL        VAR(&DBPREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&FLDLEN) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&DTANAME) TYPE(*CHAR) LEN(10)
/**********  DCL        VAR(&DTALIB) TYPE(*CHAR) LEN(10) */                              /*BUG6129*/
             DCL        VAR(&DILIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(10)                                   /*CPK015*/
             DCL        VAR(&OWNER) TYPE(*CHAR) LEN(10) /*CPK015*/
             DCL        VAR(&WAIT) TYPE(*DEC) LEN(5 0) VALUE(0)
             DCL        VAR(&SEQN) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&SEQA) TYPE(*CHAR) LEN(5)
             DCL        VAR(&LAYOUT) TYPE(*CHAR) LEN(10)
             DCL        VAR(&KEY_LEN) TYPE(*DEC) LEN(3 0) VALUE(10)
                                                                                          /*CSC022*/
             DCL        VAR(&JBNM) TYPE(*CHAR) LEN(10)                                    /*CSC022*/
             DCL        VAR(&SCCMTJOB) TYPE(*CHAR) LEN(256)                               /*CSC022*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                                     /*CSC022*/
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(7)                                   /*CSC022*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                                      /*CSC022*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)                                 /*CSC022*/
             DCL        VAR(&CSC022) TYPE(*CHAR) LEN(1) VALUE(' ')                        /*CSC022*/
             DCL        VAR(&CMTNUM) TYPE(*DEC) LEN(3 0)                                  /*CSC022*/
             DCL        VAR(&CMTJOB1) TYPE(*CHAR) LEN(10)                                 /*CSC022*/
             DCL        VAR(&CMTJOB2) TYPE(*CHAR) LEN(10)                                 /*CSC022*/
             DCL        VAR(&CMTJOB3) TYPE(*CHAR) LEN(10)                                 /*CSC022*/
             DCL        VAR(&CMTJOB4) TYPE(*CHAR) LEN(10)                                 /*CSC022*/
             DCL        VAR(&CMTJOB5) TYPE(*CHAR) LEN(10)                                 /*CSC022*/
             DCL        VAR(&CMTJOB6) TYPE(*CHAR) LEN(10)                                 /*CSC022*/
             DCL        VAR(&CMTJOB7) TYPE(*CHAR) LEN(10)                                 /*CSC022*/
             DCL        VAR(&CMTJOB8) TYPE(*CHAR) LEN(10)                                 /*CSC022*/
             DCL        VAR(&CMTJOB9) TYPE(*CHAR) LEN(10)                                 /*CSC022*/
             DCL        VAR(&CMTJOB10) TYPE(*CHAR) LEN(10)                                /*CSC022*/
             DCL        VAR(&CRSKIP) TYPE(*CHAR) LEN(1) VALUE(' ')                        /*CSC022*/
                                                                                          /*CSC022*/
             CHGVAR     VAR(&CSC022) VALUE('N')                                           /*CSC022*/
             CHGVAR     VAR(&CRSKIP) VALUE('N')                                           /*CSC022*/
             CHGVAR     VAR(&RTNCDE) VALUE('       ')                                     /*CSC022*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CSC022*/
             CHGVAR     VAR(&SAR) VALUE('CSC022')                                         /*CSC022*/
                                                                                          /*CSC022*/
/* */
/* Global Monitor Message */
/* */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
 /**/                                                                                     /*CSC022*/
 /** Call AO Switchable features  */                                                      /*CSC022*/
 /**/                                                                                     /*CSC022*/
             CALL       PGM(AOSARDR0) PARM(&RTNCDE &OPTN &SAR &SCSARD)                    /*CSC022*/
                                                                                          /*CSC022*/
             IF         COND(&RTNCDE *EQ '       ') THEN(DO)                              /*CSC022*/
             CHGVAR     VAR(&CSC022) VALUE('Y')                                           /*CSC022*/
             RTVDTAARA  DTAARA(SCCMTJOB (1 256)) RTNVAR(&SCCMTJOB)                        /*CSC022*/
             CHGVAR     VAR(&CMTNUM) VALUE(%SST(&SCCMTJOB 1 3))                           /*CSC022*/
             CHGVAR     VAR(&CMTJOB1) VALUE(%SST(&SCCMTJOB 4 10))                         /*CSC022*/
             CHGVAR     VAR(&CMTJOB2) VALUE(%SST(&SCCMTJOB 14 10))                        /*CSC022*/
             CHGVAR     VAR(&CMTJOB3) VALUE(%SST(&SCCMTJOB 24 10))                        /*CSC022*/
             CHGVAR     VAR(&CMTJOB4) VALUE(%SST(&SCCMTJOB 34 10))                        /*CSC022*/
             CHGVAR     VAR(&CMTJOB5) VALUE(%SST(&SCCMTJOB 44 10))                        /*CSC022*/
             CHGVAR     VAR(&CMTJOB6) VALUE(%SST(&SCCMTJOB 54 10))                        /*CSC022*/
             CHGVAR     VAR(&CMTJOB7) VALUE(%SST(&SCCMTJOB 64 10))                        /*CSC022*/
             CHGVAR     VAR(&CMTJOB8) VALUE(%SST(&SCCMTJOB 74 10))                        /*CSC022*/
             CHGVAR     VAR(&CMTJOB9) VALUE(%SST(&SCCMTJOB 84 10))                        /*CSC022*/
             CHGVAR     VAR(&CMTJOB10) VALUE(%SST(&SCCMTJOB 94 10))                       /*CSC022*/
                                                                                          /*CSC022*/
             IF         COND((&CMTNUM *GT 0) *AND (&CMTJOB1 *EQ +
                          &JBNM)) THEN(DO)                                                /*CSC022*/
             CHGVAR     VAR(&CRSKIP) VALUE('Y')                                           /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 1) *AND (&CMTJOB2 *EQ +
                          &JBNM))    THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CRSKIP) VALUE('Y')                                           /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 2) *AND (&CMTJOB3 *EQ +
                          &JBNM))    THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CRSKIP) VALUE('Y')                                           /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 3) *AND (&CMTJOB4 *EQ +
                          &JBNM))    THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CRSKIP) VALUE('Y')                                           /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 4) *AND (&CMTJOB5 *EQ +
                          &JBNM))    THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CRSKIP) VALUE('Y')                                           /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 5) *AND (&CMTJOB6 *EQ +
                          &JBNM))    THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CRSKIP) VALUE('Y')                                           /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 6) *AND (&CMTJOB7 *EQ +
                          &JBNM))    THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CRSKIP) VALUE('Y')                                           /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 7) *AND (&CMTJOB8 *EQ +
                          &JBNM))    THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CRSKIP) VALUE('Y')                                           /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 8) *AND (&CMTJOB9 *EQ +
                          &JBNM))    THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CRSKIP) VALUE('Y')                                           /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 9) *AND (&CMTJOB10 *EQ +
                          &JBNM))    THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CRSKIP) VALUE('Y')                                           /*CSC022*/
             ENDDO                                                                        /*CSC022*/
                                                                                          /*CSC022*/
             ENDDO                                                                        /*CSC022*/
 /**/                                                                                     /*CSC022*/
/* */
/* Set switches and return code */
/* */
             CHGJOB     SWS(XXXXX000)
             CHGVAR     VAR(&RTN_CODE) VALUE(' ')
/* */
/*       Retrieve the job number      */
/* */
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&JOBNUM)
/* */
/*       Set up DILIB name            */
/* */
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&DBPREFIX)
             CHGVAR     VAR(&DILIB) VALUE(&DBPREFIX *CAT 'DILIB')
             CHGVAR     VAR(&DPLIB) VALUE(&DBPREFIX *CAT 'DPLIB')                         /*CPK015*/
 
             RTVOBJD    OBJ(&DPLIB) OBJTYPE(*LIB) OWNER(&OWNER)                           /*CPK015*/
/* */
/* Check job data queue exists */
/* */
             CHGVAR     VAR(&DQUEUE) VALUE('UDC' *CAT &JOBNUM)
/* */
             CHKOBJ     OBJ(QTEMP/&DQUEUE) OBJTYPE(*DTAQ)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CRTDTAQ    DTAQ(QTEMP/&DQUEUE) MAXLEN(256) TEXT('Data +
                          queue for UDC Allocation')
             ENDDO
/* */
/*       If deallocate read queue                                    */
/* */
             IF         COND(&ACTION *EQ 'Deallocate') THEN(DO)
             CHGVAR     VAR(&FLDLEN) VALUE(30)
/* */
/*       Read dataqueue until empty                                  */
/* */
 READ:       CALL       PGM(QRCVDTAQ) PARM(&DQUEUE 'QTEMP' &FLDLEN +
                          &DATA &WAIT)
/* */
             IF         COND(&FLDLEN *GT 0) THEN(DO)
/* */
/* Deallocate dataareas */
/* */
             CHGVAR     VAR(&DTANAME) VALUE(%SST(&DATA 1 10))
/**********  CHGVAR     VAR(&DTALIB) VALUE(%SST(&DATA 11 10)) */                         /*BUG6129*/
/**********  DLCOBJ     OBJ((&DTALIB/&DTANAME *DTAARA *SHRRD)) */                        /*BUG6129*/
/**********  DLCOBJ     OBJ((&DTALIB/&DTANAME *DTAARA *EXCL)) */                         /*BUG6129*/
             DLCOBJ     OBJ((*LIBL/&DTANAME *DTAARA *SHRRD))                             /*BUG6129*/
             DLCOBJ     OBJ((*LIBL/&DTANAME *DTAARA *EXCL))                              /*BUG6129*/
             GOTO       CMDLBL(READ)
             ENDDO
/**/
             GOTO       CMDLBL(ENDCLPGM)
/* */
             ENDDO
/* */
/*       If Allocate then get new name and create data area        */
/* */
             IF         COND(&ACTION *EQ 'Allocate  ') THEN(DO)
             CHGVAR     VAR(&LAYOUT) VALUE(%SST(&KEY_INFO 1 10))
/* */
/*       Check for allocation data queue                           */
/* */
/**********                                                           */                  /*CPK015*/
/**********  CHKOBJ     OBJ(&DILIB/CGALLOC) OBJTYPE(*DTAQ) */                             /*CPK015*/
/**********  CHKOBJ     OBJ(CGALLOC) OBJTYPE(*DTAQ)                   */                  /*CPK015*/
/**********  MONMSG     MSGID(CPF9801) EXEC(DO)                       */                  /*CPK015*/
/***/                                                                                     /*CPK015*/
/**Send*Message*to*MRUNQ**/                                                               /*CPK015*/
/***/                                                                                     /*CPK015*/
/**********  SNDPGMMSG  MSG('CGC8100 - Create data queue CGALLOC') +  */                  /*CPK015*/
/**********               TOMSGQ(MRUNQ)                               */                  /*CPK015*/
/**********  CHGVAR     VAR(&FLDLEN) VALUE(256)                       */                  /*CPK015*/
/**********  CRTDTAQ    DTAQ(&DILIB/CGALLOC) MAXLEN(&FLDLEN) +        */                  /*CPK015*/
/**********               SEQ(*KEYED) KEYLEN(&KEY_LEN) TEXT('CG +     */                  /*CPK015*/
/**********               Data queue for Allocation') +               */                  /*CPK015*/
/**********               SENDERID(*YES) AUT(*LIBCRTAUT)              */                  /*CPK015*/
/**********  ENDDO                                                    */                  /*CPK015*/
/* */
/*       Allocate CGALLOC to stop other jobs                       */
/* */
/**********  ALCOBJ     OBJ((&DILIB/CGALLOC *DTAQ *EXCL)) WAIT(120) */                    /*CPK015*/
             ALCOBJ     OBJ((CGALLOC *DTAQ *EXCL)) WAIT(120)                              /*CPK015*/
             MONMSG     MSGID(CPF1002 CPF1085) EXEC(DO)
             CHGVAR     VAR(&RTN_CODE) VALUE('*IN USE')
             GOTO       CMDLBL(ENDCLPGM)
             ENDDO
/* */
/*       Get layout entry if exists                                */
/* */
             CHGVAR     VAR(&WAIT) VALUE(1)
             CHGVAR     VAR(&ORDER) VALUE('EQ')
             CHGVAR     VAR(&KEY) VALUE(&LAYOUT)
             CHGVAR     VAR(&FLDLEN) VALUE(30)
/**********  CALL       PGM(QRCVDTAQ) PARM('CGALLOC' &DILIB &FLDLEN + */                  /*CPK015*/
/**********               &DATA &WAIT &ORDER &KEY_LEN &KEY +          */                  /*CPK015*/
/**********               &SNDR_LEN &SNDR)                            */                  /*CPK015*/
             CALL       PGM(QRCVDTAQ) PARM('CGALLOC' '*LIBL' &FLDLEN +
                          &DATA &WAIT &ORDER &KEY_LEN &KEY +
                          &SNDR_LEN &SNDR)                                                /*CPK015*/
/* */
             CHGVAR     VAR(&DTANAME) VALUE(%SST(&DATA 1 10))
/* */
/*       If nothing create new data area                           */
/* */
             IF         COND(&FLDLEN *LT 1) THEN(DO)
/* */
             RTVDTAARA  DTAARA(CGDTA (156 5)) RTNVAR(&SEQA)
/* */
/*       If blank set to zero                                      */
/* */
             IF         COND(&SEQA *EQ '     ') THEN(DO)
             CHGVAR     VAR(&SEQA) VALUE('00000')
             ENDDO
/* */
/*       Step sequence on                                          */
/* */
             CHGVAR     VAR(&SEQN) VALUE(&SEQA)
             CHGVAR     VAR(&SEQN) VALUE(&SEQN + 1)
             CHGVAR     VAR(&SEQA) VALUE(&SEQN)
             CHGDTAARA  DTAARA(CGDTA (156 5)) VALUE(&SEQA)
/* */
             CHGVAR     VAR(&DTANAME) VALUE('UDC' *CAT &SEQA)
             CHGVAR     VAR(&DATA) VALUE('UDC' *CAT &SEQA)
/* */
/*       Check that data area exists                                 */
/* */
/************CHKOBJ     OBJ(&DILIB/&DTANAME) OBJTYPE(*DTAARA)                          */ /*CPK015*/
             CHKOBJ     OBJ(&DTANAME) OBJTYPE(*DTAARA)                                    /*CPK015*/
             MONMSG     MSGID(CPF9801) EXEC(DO)
/************CRTDTAARA  DTAARA(&DILIB/&DTANAME) TYPE(*CHAR) LEN(512) +                 */ /*CPK015*/
/************             VALUE(&LAYOUT) TEXT('UDC Allocation +                        */ /*CPK015*/
/************             dataarea') AUT(*ALL)                                         */ /*CPK015*/
             CRTDTAARA  DTAARA(&DPLIB/&DTANAME) TYPE(*CHAR) LEN(512) +
                          VALUE(&LAYOUT) TEXT('UDC Allocation +
                          dataarea') AUT(*LIBCRTAUT)                                      /*CPK015*/
             CHGOBJOWN  OBJ(&DTANAME) OBJTYPE(*DTAARA) NEWOWN(&OWNER)                     /*CPK015*/
             ENDDO
/* */
             ENDDO
/* */
/*       Place entry back on data queue                              */
/* */
             CHGVAR     VAR(&FLDLEN) VALUE(30)
/**********  CALL       PGM(QSNDDTAQ) PARM('CGALLOC' &DILIB &FLDLEN + */                  /*CPK015*/
/**********               &DATA &KEY_LEN &LAYOUT)                     */                  /*CPK015*/
             CALL       PGM(QSNDDTAQ) PARM('CGALLOC' '*LIBL' &FLDLEN +
                          &DATA &KEY_LEN &LAYOUT)                                         /*CPK015*/
/* */
/*       Allocate dataarea                                           */
/* */
/************ALCOBJ     OBJ((&DILIB/&DTANAME *DTAARA *EXCL)) WAIT(5)                   */ /*CPK015*/
             ALCOBJ     OBJ((&DTANAME *DTAARA *EXCL)) WAIT(5)                             /*CPK015*/
             MONMSG     MSGID(CPF1002 CPF1085) EXEC(DO)
/* */
/*       If in use get information on data area                      */
/* */
/************RTVDTAARA  DTAARA(&DILIB/&DTANAME (1 80)) +                               */ /*CPK015*/
/************             RTNVAR(&KEY_INFO)                                            */ /*CPK015*/
             RTVDTAARA  DTAARA(&DTANAME (1 80)) RTNVAR(&KEY_INFO)                         /*CPK015*/
             MONMSG     MSGID(CPF0000) EXEC(DO)
             CHGVAR     VAR(&KEY_INFO) VALUE(' ')
             ENDDO
             CHGVAR     VAR(&RTN_CODE) VALUE('*IN USE')
             GOTO       CMDLBL(ENDCLPGM)
             ENDDO
/* */
/*       Send data queue entry                                       */
/* */
/*********** CHGVAR     VAR(&DATA) VALUE(&DTANAME *CAT &DILIB)                         */ /*219770*/
             CHGVAR     VAR(&DATA) VALUE(&DTANAME *CAT &DPLIB)                            /*219770*/
             CHGVAR     VAR(&FLDLEN) VALUE(30)
             CALL       PGM(QSNDDTAQ) PARM(&DQUEUE 'QTEMP' &FLDLEN +
                          &DATA)
/* */
/*       Place job information in dataarea                           */
/* */
/************CHGDTAARA  DTAARA(&DILIB/&DTANAME (20 26)) VALUE(&JOB +                   */ /*CPK015*/
/************             *CAT &USER *CAT &JOBNUM)                                     */ /*CPK015*/
             CHGDTAARA  DTAARA(&DTANAME (20 26)) VALUE(&JOB *CAT +
                          &USER *CAT &JOBNUM)                                             /*CPK015*/
/* */
/*       Allocate to *SHRRD state                                    */
/* */
/************ALCOBJ     OBJ((&DILIB/&DTANAME *DTAARA *SHRRD)) WAIT(5)                  */ /*CPK015*/
/************DLCOBJ     OBJ((&DILIB/&DTANAME *DTAARA *EXCL))                           */ /*CPK015*/
             ALCOBJ     OBJ((&DTANAME *DTAARA *SHRRD)) WAIT(5)                            /*CPK015*/
             DLCOBJ     OBJ((&DTANAME *DTAARA *EXCL))                                     /*CPK015*/
/* */
/*       Blank return code and exit                                  */
/* */
             CHGVAR     VAR(&RTN_CODE) VALUE('       ')
             GOTO       CMDLBL(ENDCLPGM)
/* */
             ENDDO
/* */
/* */
/* Check for Database errors trapped by program */
/* */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&ERR_DATA) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
/**/
             GOTO       CMDLBL(ENDCLPGM)
/**/
/* Abnormal termination processing                       */
/**/
ABNORMAL:
 /**/                                                                                     /*CSC022*/
 /** Execute rollback if SAR CSC022 is not enrolled or */                                 /*CSC022*/
 /**   job is not currently running in batch mode */                                      /*CSC022*/
 /**/                                                                                     /*CSC022*/
             IF         COND((&CSC022 *EQ 'N') *OR ((&CSC022 *EQ 'Y' +
                          *AND &CRSKIP *EQ 'N'))) THEN(DO)                                /*CSC022*/
             ROLLBACK
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program CGC8100 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          CGC8100 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
                                                                                          /*CSC022*/
             ENDDO                                                                        /*CSC022*/
                                                                                          /*CSC022*/
/**/
 ENDCLPGM:
/* */
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/* */
/*     Deallocate CGALLOC                                          */
/* */
/**********  DLCOBJ     OBJ((&DILIB/CGALLOC *DTAQ *EXCL)) */                              /*CPK015*/
             DLCOBJ     OBJ((CGALLOC *DTAQ *EXCL))                                        /*CPK015*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/* */
             ENDPGM
