/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SC Rep last sucs. trans on primy m/c')          */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       SDC1774 - Control Rebuild access paths                      */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSC023             Date 02Feb04              */
/*                      CPK016             Date 29Aug03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CPK014             Date 14Nov01              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      110242             Date 07NOV96              */
/*                      S01408             DATE 10MAY95              */
/*                      081177             DATE 07MAR95              */
/*                      066987             DATE 08APR94              */
/*                      E29436             DATE 11OCT91              */
/*                      S01337             DATE 20DEC90              */
/*                      E20391             DATE 26NOV89              */
/*                      E13205             DATE 14APR89              */
/*                                                                   */
/*********************************************************************/
/*       New program overview                                        */
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CPK016 - Release 5 packaging.  Make data queue REBUILD      */
/*                permanent.                                         */
/*       CPK014 - Submit jobs with user *JOBD                        */
/*       110242 - Change defaults for SBMJOB cmd to take *JOBD       */
/*       S01408 - Addition of core hook SDC1774MPS                   */
/*     081177 - Use Job Description library list instead of current */
/*              library list when submitting job                    */
/*            - Correct member text name                            */
/*       066987 - Error msg should say SDC1772 instead of SDC1722.   */
/*       E29436 - MOVE TO SCCLSRC FROM RR.                           */
/*       S01337 - SPLIT 'D' LIBRARY INTO 'DP' AND 'DV' LIBRAIRES     */
/*       E20391 - RTGDTA(*JOBD) ADDED TO ALL SBMJOB CMDS.            */
/*       E13205 - If switch 1 is off build only unique paths         */
/*                else rebuild all paths in the DLIB and update      */
/*                SD1724 via displaying Logical files.               */
/*                                                                   */
/*                If the program is called interactively with        */
/*                switch 1 on then LGLMBR creation is skipped.       */
/*                                                                   */
/*                This program is called by SDC1720 and SDC1721      */
/*                with switch 1 off. This means that when the        */
/*                program terminates, all unique paths should        */
/*                have been rebuilt.                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
/*           Declare variables                                       */
/**/
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(30)
/**********  DCL        VAR(&DLIB) TYPE(*CHAR) LEN(10)                 *S01337*/
             DCL        VAR(&DVLIB) TYPE(*CHAR) LEN(10)               /*S01337*/
/**********  DCL        VAR(&JLIB) TYPE(*CHAR) LEN(10)                                 */ /*CPK016*/
             DCL        VAR(&FLDLEN) TYPE(*DEC) LEN(5 0) VALUE(30)
             DCL        VAR(&DBPREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&INT_ACT) TYPE(*CHAR) LEN(1)
/**/
             DCLF       FILE(*LIBL/QAFDMBRL)
/**/
/*           Global Monitor message                                  */
/**/
             MONMSG     MSGID(MCH0000 CPF0000) EXEC(GOTO CMDLBL(ABNOR))
/**/
             RTVJOBA    TYPE(&INT_ACT)
             RTVDTAARA  DTAARA(*LIBL/SDSTAT (6 2)) RTNVAR(&DBPREFIX)
/**********  CHGVAR     VAR(&JLIB) VALUE(&DBPREFIX *CAT 'JLIB')                        */ /*CPK016*/
/************CHGVAR     VAR(&DLIB) VALUE(&DBPREFIX *CAT 'DLIB')        *S01337*/
             CHGVAR     VAR(&DVLIB) VALUE(&DBPREFIX *CAT 'DVLIB')     /*S01337*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SDC1774MPS                                          */
                                                                      /*S01408*/
/**/
/*           Set rebuild flags on file SD1724 to 'N'                 */
/**/
/**********  CALL       PGM(*LIBL/SD1731) PARM('*ALLOFF' ' ' &DLIB ' + *S01337*/
/**********               ' &RTNCDE)                                   *S01337*/
             CALL      PGM(*LIBL/SD1731) PARM('*ALLOFF' ' ' &DVLIB ' +
                          ' &RTNCDE)                                  /*S01337*/
             IF         COND(&RTNCDE *EQ '*ERROR') THEN(GOTO +
                          CMDLBL(ABNOR))
/**/
/************Recreate*data*queue*in*JLIB*for*rebuild*access*paths*****/ /*             */ /*CPK016*/
/**********                                                                            */ /*CPK016*/
/**********  DLTDTAQ    DTAQ(&JLIB/REBUILD)                                            */ /*CPK016*/
/**********  MONMSG     MSGID(CPF2105)                                                 */ /*CPK016*/
/**********  CRTDTAQ    DTAQ(&JLIB/REBUILD) MAXLEN(128) SEQ(*FIFO) +                   */ /*CPK016*/
/**********               TEXT('Queue of files to rebuild')                            */ /*CPK016*/
 
/* Clear REBUILD data queue. */                                                           /*CPK016*/
             CALL       PGM(QCLRDTAQ) PARM('REBUILD' '*LIBL ')                            /*CPK016*/
 
/**/
/*           If switch 1 is off then rebuild unique paths only       */
/*           and no need to construct file                           */
/*           If switch 1 is on  then a rebuild of all *IMMED files   */
/*           and if interactive do not construct file                */
/**/
             IF         COND(%SWITCH(0XXXXXXX)) THEN(DO)
             OVRDBF     FILE(SD1724L0) SHARE(*YES)
             OPNQRYF    FILE((*LIBL/SD1724L0)) QRYSLT('UNIQUE *EQ "Y"')
             ENDDO
             ELSE       CMD(DO)
             OVRDBF     FILE(SD1724L0) SHARE(*YES)
             OPNQRYF    FILE((*LIBL/SD1724L0)) QRYSLT('ACCPTH *NE "N"')
             ENDDO
/**/
/*           Place entries onto data queue REBUILD                   */
/*           and submit job to rebuild paths                         */
/**/
             CALL       PGM(*LIBL/SDC1773)
             IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO +
                          CMDLBL(ABNOR))
/************SBMJOB     JOB(ALL_FILES) JOBD(*LIBL/MEODD) +                                /*CPK014*/
/************             JOBQ(*LIBL/MEODQ) RTGDTA(*JOBD) +                               /*CPK014*/
/************             RQSDTA('Call SDC1772') INLLIBL(*JOBD) +                         /*CPK014*/
/************             MSGQ(*LIBL/MOPERQ)                          /*081177*/          /*CPK014*/
/************SBMJOB     JOB(ALL_FILES) JOBD(*LIBL/MEODD) +                                /*CPK014*/
/************             JOBQ(*LIBL/MEODQ) RTGDTA(*JOBD) +                               /*CPK014*/
/************             RQSDTA('Call SDC1772') INLLIBL(*JOBD) +                         /*CPK014*/
/************             MSGQ(*LIBL/MOPERQ)                          /*081177*/          /*CPK014*/
/************SBMJOB     JOB(ALL_FILES) JOBD(*LIBL/MEODD) +                                /*CPK014*/
/************             JOBQ(*LIBL/MEODQ) RTGDTA(*JOBD) +                               /*CPK014*/
/************             RQSDTA('Call SDC1772') INLLIBL(*JOBD) +                         /*CPK014*/
/************             MSGQ(*LIBL/MOPERQ)                          /*081177*/          /*CPK014*/
/************                                                          *081177*/
/************SBMJOB     JOB(ALL_FILES) JOBD(*LIBL/MEODD) +             *081177*/
/************             JOBQ(*LIBL/MEODQ) RQSDTA('Call SDC1772') +   *081177*/
/************             MSGQ(*LIBL/MOPERQ) RTGDTA(*JOBD)      /*E20391081177*/
/***********              MSGQ(*LIBL/MOPERQ)                          /*E20391*/
/************SBMJOB     JOB(ALL_FILES) JOBD(*LIBL/MEODD) +             *081177*/
/************             JOBQ(*LIBL/MEODQ) RQSDTA('Call SDC1772') +   *081177*/
/************             MSGQ(*LIBL/MOPERQ) RTGDTA(*JOBD)     /*E20391*081177*/
/***********              MSGQ(*LIBL/MOPERQ)                          /*E20391*/
/************SBMJOB     JOB(ALL_FILES) JOBD(*LIBL/MEODD) +            /*110242*/
/*************            JOBQ(*LIBL/MEODQ) RQSDTA('Call SDC1772') +  /*110242*/
/*************            MSGQ(*LIBL/MOPERQ) RTGDTA(*JOBD) */  /*E20391 110242*/
/***********              MSGQ(*LIBL/MOPERQ)                          /*E20391*/
/************SBMJOB     JOB(ALL_FILES) JOBD(*LIBL/MEODD) +                                /*CPK014*/
/************             JOBQ(*LIBL/MEODQ) RTGDTA(*JOBD) +                               /*CPK014*/
/************             RQSDTA('Call SDC1772') INLLIBL(*JOBD) +                         /*CPK014*/
/************             MSGQ(*LIBL/MOPERQ)                          /*110242*/          /*CPK014*/
                                                                                          /*CPK014*/
/************SBMJOB     JOB(ALL_FILES) JOBD(*LIBL/MEODD) +                                /*CSC023*/
/************             JOBQ(*LIBL/MEODQ) USER(*JOBD) +                                 /*CSC023*/
/************             RTGDTA(*JOBD) RQSDTA('CALL SDC1772') +                          /*CSC023*/
/************             INLLIBL(*JOBD) MSGQ(*LIBL/MOPERQ)                    /*CPK014*/ /*CSC023*/
                                                                                          /*CPK014*/
/************SBMJOB     JOB(ALL_FILES) JOBD(*LIBL/MEODD) +                                /*CSC023*/
/************             JOBQ(*LIBL/MEODQ) USER(*JOBD) +                                 /*CSC023*/
/************             RTGDTA(*JOBD) RQSDTA('CALL SDC1772') +                          /*CSC023*/
/************             INLLIBL(*JOBD) MSGQ(*LIBL/MOPERQ)                    /*CPK014*/ /*CSC023*/
                                                                                          /*CPK014*/
/************SBMJOB     JOB(ALL_FILES) JOBD(*LIBL/MEODD) +                                /*CSC023*/
/************             JOBQ(*LIBL/MEODQ) USER(*JOBD) +                                 /*CSC023*/
/************             RTGDTA(*JOBD) RQSDTA('CALL SDC1772') +                          /*CSC023*/
/************             INLLIBL(*JOBD) MSGQ(*LIBL/MOPERQ)                    /*CPK014*/ /*CSC023*/
                                                                                          /*CPK014*/
/************SBMJOB     JOB(ALL_FILES) JOBD(*LIBL/MEODD) +                                /*CSC023*/
/************             JOBQ(*LIBL/MEODQ) USER(*JOBD) +                                 /*CSC023*/
/************             RTGDTA(*JOBD) RQSDTA('CALL SDC1772') +                          /*CSC023*/
/************             INLLIBL(*JOBD) MSGQ(*LIBL/MOPERQ)                    /*CPK014*/ /*CSC023*/
                                                                                          /*CSC023*/
             SBMJOB     JOB(ALL_FILES) JOBD(*LIBL/MEODD) +
                          JOBQ(*LIBL/MEODQ) USER(*JOBD) +
                          RTGDTA(*JOBD) RQSDTA('CALL SDC1772') +
                          INLLIBL(*JOBD) MSGQ(*LIBL/MOPERQ) OUTQ(*JOBD)                   /*CSC023*/
                                                                                          /*CSC023*/
             SBMJOB     JOB(ALL_FILES) JOBD(*LIBL/MEODD) +
                          JOBQ(*LIBL/MEODQ) USER(*JOBD) +
                          RTGDTA(*JOBD) RQSDTA('CALL SDC1772') +
                          INLLIBL(*JOBD) MSGQ(*LIBL/MOPERQ) OUTQ(*JOBD)                   /*CSC023*/
                                                                                          /*CSC023*/
             SBMJOB     JOB(ALL_FILES) JOBD(*LIBL/MEODD) +
                          JOBQ(*LIBL/MEODQ) USER(*JOBD) +
                          RTGDTA(*JOBD) RQSDTA('CALL SDC1772') +
                          INLLIBL(*JOBD) MSGQ(*LIBL/MOPERQ) OUTQ(*JOBD)                   /*CSC023*/
                                                                                          /*CSC023*/
             SBMJOB     JOB(ALL_FILES) JOBD(*LIBL/MEODD) +
                          JOBQ(*LIBL/MEODQ) USER(*JOBD) +
                          RTGDTA(*JOBD) RQSDTA('CALL SDC1772') +
                          INLLIBL(*JOBD) MSGQ(*LIBL/MOPERQ) OUTQ(*JOBD)                   /*CSC023*/
/**/
/*           Close open query file used in SDC1773                   */
/**/
             CLOF       OPNID(SD1724L0)
/**/
/*           If switch 1 is off then this is an interactive rebuild  */
/*           with no generation of LGLMBR                            */
/**/
             IF         COND(%SWITCH(0XXXXXXX)) THEN(GOTO +
                          CMDLBL(CALL_PGM))
             IF         COND(&INT_ACT *EQ '1') THEN(GOTO +
                          CMDLBL(CALL_PGM))
/**/
/*           Display all logical members to LGLMBR.QTEMP             */
/**/
/**********  DSPFD      FILE(&DLIB/*ALL) TYPE(*MBRLIST) +              *S01337*/
/**********               OUTPUT(*OUTFILE) OUTFILE(QTEMP/LGLMBR) +     *S01337*/
/**********               FILEATR(*LF)                                 *S01337*/
             DSPFD      FILE(&DVLIB/*ALL) TYPE(*MBRLIST) +
                          OUTPUT(*OUTFILE) OUTFILE(QTEMP/LGLMBR) +
                          FILEATR(*LF)                                /*S01337*/
/**/
/*           Read until end of file                                  */
/**/
             OVRDBF     FILE(QAFDMBRL) TOFILE(QTEMP/LGLMBR)
 READ:       RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(SUBMIT))
/**/
/*           Format entry and send to queue                          */
/**/
             CHGVAR     VAR(&DATA) VALUE(&MLFILE *CAT &MLLIB *CAT +
                          &MLNAME)
/**********  CALL       PGM(*LIBL/QSNDDTAQ) PARM('REBUILD' &JLIB +                     */ /*CPK016*/
/**********               &FLDLEN &DATA)                                               */ /*CPK016*/
             CALL       PGM(*LIBL/QSNDDTAQ) PARM('REBUILD' '*LIBL' +
                          &FLDLEN &DATA)                                                  /*CPK016*/
/**/
             GOTO       CMDLBL(READ)
 SUBMIT:
/**/
/*           Submit Job to MEODQ with job description MEODD          */
/**/
/************SBMJOB     JOB(ALL_FILES) JOBD(*LIBL/MEODD) +            /*110242*/
/*************            JOBQ(*LIBL/MEODQ) RQSDTA('Call SDC1772') +  /*110242*/
/*************            MSGQ(*LIBL/MOPERQ) RTGDTA(*JOBD)            /*E20391*/
/***********              MSGQ(*LIBL/MOPERQ)                          /*E20391*/
/************SBMJOB     JOB(ALL_FILES) JOBD(*LIBL/MEODD) +            /*110242*/
/*************            JOBQ(*LIBL/MEODQ) RQSDTA('Call SDC1772') +  /*110242*/
/*************            MSGQ(*LIBL/MOPERQ) RTGDTA(*JOBD)            /*E20391*/
/***********              MSGQ(*LIBL/MOPERQ)                          /*E20391*/
/************SBMJOB     JOB(ALL_FILES) JOBD(*LIBL/MEODD) +            /*110242*/
/*************            JOBQ(*LIBL/MEODQ) RQSDTA('Call SDC1772') +  /*110242*/
/*************            MSGQ(*LIBL/MOPERQ) RTGDTA(*JOBD)            /*E20391*/
/***********              MSGQ(*LIBL/MOPERQ)                          /*E20391*/
/************SBMJOB     JOB(ALL_FILES) JOBD(*LIBL/MEODD) +            /*110242*/
/*************            JOBQ(*LIBL/MEODQ) RQSDTA('Call SDC1772') +  /*110242*/
/*************            MSGQ(*LIBL/MOPERQ) RTGDTA(*JOBD)            /*E20391*/
/***********              MSGQ(*LIBL/MOPERQ)                          /*E20391*/
                                                                      /*110242*/
/************SBMJOB     JOB(ALL_FILES) JOBD(*LIBL/MEODD) +                                /*CPK014*/
/************             JOBQ(*LIBL/MEODQ) RTGDTA(*JOBD) +                               /*CPK014*/
/************             RQSDTA('Call SDC1772') INLLIBL(*JOBD) +                         /*CPK014*/
/************             MSGQ(*LIBL/MOPERQ)                          /*110242*/          /*CPK014*/
/************SBMJOB     JOB(ALL_FILES) JOBD(*LIBL/MEODD) +                                /*CPK014*/
/************             JOBQ(*LIBL/MEODQ) RTGDTA(*JOBD) +                               /*CPK014*/
/************             RQSDTA('Call SDC1772') INLLIBL(*JOBD) +                         /*CPK014*/
/************             MSGQ(*LIBL/MOPERQ)                          /*110242*/          /*CPK014*/
/************SBMJOB     JOB(ALL_FILES) JOBD(*LIBL/MEODD) +                                /*CPK014*/
/************             JOBQ(*LIBL/MEODQ) RTGDTA(*JOBD) +                               /*CPK014*/
/************             RQSDTA('Call SDC1772') INLLIBL(*JOBD) +                         /*CPK014*/
/************             MSGQ(*LIBL/MOPERQ)                          /*110242*/          /*CPK014*/
/************SBMJOB     JOB(ALL_FILES) JOBD(*LIBL/MEODD) +                                /*CPK014*/
/************             JOBQ(*LIBL/MEODQ) RTGDTA(*JOBD) +                               /*CPK014*/
/************             RQSDTA('Call SDC1772') INLLIBL(*JOBD) +                         /*CPK014*/
/************             MSGQ(*LIBL/MOPERQ)                          /*110242*/          /*CPK014*/
 
/************SBMJOB     JOB(ALL_FILES) JOBD(*LIBL/MEODD) +                                /*CSC023*/
/************             JOBQ(*LIBL/MEODQ) USER(*JOBD) +                                 /*CSC023*/
/************             RTGDTA(*JOBD) RQSDTA('CALL SDC1772') +                          /*CSC023*/
/************             INLLIBL(*JOBD) MSGQ(*LIBL/MOPERQ)                    /*CPK014*/ /*CSC023*/
                                                                                          /*CPK014*/
/************SBMJOB     JOB(ALL_FILES) JOBD(*LIBL/MEODD) +                                /*CSC023*/
/************             JOBQ(*LIBL/MEODQ) USER(*JOBD) +                                 /*CSC023*/
/************             RTGDTA(*JOBD) RQSDTA('CALL SDC1772') +                          /*CSC023*/
/************             INLLIBL(*JOBD) MSGQ(*LIBL/MOPERQ)                    /*CPK014*/ /*CSC023*/
                                                                                          /*CPK014*/
/************SBMJOB     JOB(ALL_FILES) JOBD(*LIBL/MEODD) +                                /*CSC023*/
/************             JOBQ(*LIBL/MEODQ) USER(*JOBD) +                                 /*CSC023*/
/************             RTGDTA(*JOBD) RQSDTA('CALL SDC1772') +                          /*CSC023*/
/************             INLLIBL(*JOBD) MSGQ(*LIBL/MOPERQ)                    /*CPK014*/ /*CSC023*/
                                                                                          /*CPK014*/
/************SBMJOB     JOB(ALL_FILES) JOBD(*LIBL/MEODD) +                                /*CSC023*/
/************             JOBQ(*LIBL/MEODQ) USER(*JOBD) +                                 /*CSC023*/
/************             RTGDTA(*JOBD) RQSDTA('CALL SDC1772') +                          /*CSC023*/
/************             INLLIBL(*JOBD) MSGQ(*LIBL/MOPERQ)                    /*CPK014*/ /*CSC023*/
                                                                                          /*CSC023*/
             SBMJOB     JOB(ALL_FILES) JOBD(*LIBL/MEODD) +
                          JOBQ(*LIBL/MEODQ) USER(*JOBD) +
                          RTGDTA(*JOBD) RQSDTA('CALL SDC1772') +
                          INLLIBL(*JOBD) MSGQ(*LIBL/MOPERQ) OUTQ(*JOBD)                   /*CSC023*/
                                                                                          /*CSC023*/
             SBMJOB     JOB(ALL_FILES) JOBD(*LIBL/MEODD) +
                          JOBQ(*LIBL/MEODQ) USER(*JOBD) +
                          RTGDTA(*JOBD) RQSDTA('CALL SDC1772') +
                          INLLIBL(*JOBD) MSGQ(*LIBL/MOPERQ) OUTQ(*JOBD)                   /*CSC023*/
                                                                                          /*CSC023*/
             SBMJOB     JOB(ALL_FILES) JOBD(*LIBL/MEODD) +
                          JOBQ(*LIBL/MEODQ) USER(*JOBD) +
                          RTGDTA(*JOBD) RQSDTA('CALL SDC1772') +
                          INLLIBL(*JOBD) MSGQ(*LIBL/MOPERQ) OUTQ(*JOBD)                   /*CSC023*/
                                                                                          /*CSC023*/
             SBMJOB     JOB(ALL_FILES) JOBD(*LIBL/MEODD) +
                          JOBQ(*LIBL/MEODQ) USER(*JOBD) +
                          RTGDTA(*JOBD) RQSDTA('CALL SDC1772') +
                          INLLIBL(*JOBD) MSGQ(*LIBL/MOPERQ) OUTQ(*JOBD)                   /*CSC023*/
/**/
/*           Submit Job to update access path information            */
/**/
/************SBMJOB     JOB(ACCPTH_INF) JOBD(*LIBL/MEODD) +           /*110242*/
/*************            JOBQ(*LIBL/MEODQ) RQSDTA('call sdc1776') +  /*110242*/
/*************            MSGQ(*LIBL/MOPERQ) RTGDTA(*JOBD)            /*E20391*/
/***********              MSGQ(*LIBL/MOPERQ)                          /*E20391*/
                                                                      /*110242*/
/************SBMJOB     JOB(ACCPTH_INF) JOBD(*LIBL/MEODD) +                               /*CPK014*/
/************             JOBQ(*LIBL/MEODQ) RTGDTA(*JOBD) +                               /*CPK014*/
/************             RQSDTA('call sdc1776') INLLIBL(*JOBD) +                         /*CPK014*/
/************             MSGQ(*LIBL/MOPERQ)                          /*110242*/          /*CPK014*/
                                                                                          /*CPK014*/
/************SBMJOB     JOB(ACCPTH_INF) JOBD(*LIBL/MEODD) +                               /*CSC023*/
/************             JOBQ(*LIBL/MEODQ) USER(*JOBD) +                                 /*CSC023*/
/************             RTGDTA(*JOBD) RQSDTA('CALL SDC1776') +                          /*CSC023*/
/************             INLLIBL(*JOBD) MSGQ(*LIBL/MOPERQ)                    /*CPK014*/ /*CSC023*/
             SBMJOB     JOB(ACCPTH_INF) JOBD(*LIBL/MEODD) +
                          JOBQ(*LIBL/MEODQ) USER(*JOBD) +
                          RTGDTA(*JOBD) RQSDTA('CALL SDC1776') +
                          INLLIBL(*JOBD) MSGQ(*LIBL/MOPERQ) OUTQ(*JOBD)                   /*CSC023*/
/**/
             GOTO       CMDLBL(END)
/**/
CALL_PGM:
/*           Interactive rebuild to allow consistency                */
/**/
             CALL       PGM(*LIBL/SDC1772)
/**/
/* ATTEMPT TO ALLOCATE SDC1772 IN ORDER TO CHECK WHETHER BATCH JOBS */
/* HAVE FINISHED */
/**/
LOOP:        ALCOBJ     OBJ((SDC1772 *PGM *EXCL)) WAIT(300)
             MONMSG     MSGID(CPF1002 CPF1085) EXEC(DO)
/************SNDPGMMSG  MSG('PROGRAM SDC1774 - Unable to +        */ /*066987*/
/************                allocate SDC1722') TOPGMQ(*EXT) +    */ /*066987*/
/************                TOMSGQ(*LIBL/MOPERQ *LIBL/MRUNQ)     */ /*066987*/
             SNDPGMMSG  MSG('PROGRAM SDC1774 - Unable to +
                             allocate SDC1772') TOPGMQ(*EXT) +
                             TOMSGQ(*LIBL/MOPERQ *LIBL/MRUNQ)        /*066987*/
             GOTO LOOP
             ENDDO
             DLCOBJ     OBJ((SDC1772 *PGM *EXCL))
/**/
             GOTO       CMDLBL(END)
/**/
 ABNOR:      SNDPGMMSG  MSG('PROGRAM SDC1774 - Control Rebuild access +
                          paths - ENDED ABNORMALLY') TOPGMQ(*EXT) +
                          TOMSGQ(*LIBL/MOPERQ *LIBL/MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
END:         RCLRSC
             ENDPGM
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/**/
