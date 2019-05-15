/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CG Reset work areas and data queues')           */
/*********************************************************************/
/*                                                                   */
/*       Midas - User Defined Correspondence                         */
/*                                                                   */
/*       CGC8110  - Reset Work Areas and Data Queues                 */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*       Prev Amend No. CPK015             Date 18Apr02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      134481             Date 01May98              */
/*                      117894             Date 05Feb98              */
/*                      089168             Date 23May95              */
/*                      089167             Date 23May95              */
/*                      087936             Date 18May95              */
/*                      S01522             Date 30Dec94              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPK015 - 4.01 packaging.  Use DPLIB instead of DILIB.       */
/*       134481 - Delete of the UDC folder is before the folder name */
/*                is set up, where the value on CGDTA is blank. Fix  */
/*                is to move the DLTDLO command.                     */
/*       117894 - Update positions 7 & 8 on CGDTA with the correct   */
/*                system prefix from SDSTAT.                         */
/*       089168 - Delete and create bulk folders                     */
/*       089167 - Reset sequence for prints                          */
/*       087936 - Remove all but last confirmation                   */
/*       S01522 - User Defined Correspondence                        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&COMP_NAME &COMP_SEQ)
/* */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/* */
/* Declare variables */
/* */
             DCL        VAR(&RTN_CODE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&COMP_NAME) TYPE(*CHAR) LEN(10)
             DCL        VAR(&COMP_SEQ) TYPE(*DEC) LEN(5)
             DCL        VAR(&STATUS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(50)
             DCL        VAR(&DILIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(10)                                   /*CPK015*/
             DCL        VAR(&DBPREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&FOLDER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FOLDER_8) TYPE(*CHAR) LEN(8)
/*/COPY WNCPYSRC,CGC8110001                                          */
/* */
/* Declare Object File */
/* */
             DCLF       FILE(QADSPOBJ)
/* */
/* Global Monitor Message */
/* */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
/* */
/* Send Message to MRUNQ and standard processing parameters */
/* */
             SNDPGMMSG  MSG('CGC8110 - Reset Work Areas and Data +
                          Queues') TOMSGQ(MRUNQ)
             CHGJOB     SWS(XXXXX000)
             CHGVAR     VAR(&RTN_CODE) VALUE(' ')
/* */
/* Create data LDA in QTEMP  */
/* */
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF1023)
/*/COPY WNCPYSRC,CGC8110002                                          */
/* */
/* Format DILIB name */
/* */
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&DBPREFIX)
             CHGVAR     VAR(&DILIB) VALUE(&DBPREFIX *CAT 'DILIB')
             CHGVAR     VAR(&DPLIB) VALUE(&DBPREFIX *CAT 'DPLIB')                         /*CPK015*/
/* */
/* Get run status */
/* */
/*                                                                            */
             CHGVAR     VAR(&STATUS) VALUE(' ')
             CALL       PGM(CB0160) PARM(&COMP_NAME &COMP_SEQ &STATUS)
/* */
/* Update status to Active */
/* */
             CHGVAR     VAR(&STATUS) VALUE('Y')
             CALL       PGM(CB0150) PARM(&COMP_NAME &COMP_SEQ &STATUS)
/* */
/* Reset UDC Allocation data area number */
/* */
             CHGDTAARA  DTAARA(CGDTA (156 5)) VALUE('00000')
             CHGDTAARA  DTAARA(CGDTA (7 2)) VALUE(&DBPREFIX)          /*117894*/
/* */
/*       Check for all the *dtaara objects                           */
/* */
/************DSPOBJD    OBJ(&DILIB/UDC*) OBJTYPE(*DTAARA) +                            */ /*CPK015*/
/************             OUTPUT(*OUTFILE) OUTFILE(QTEMP/DTAFILE)                      */ /*CPK015*/
             DSPOBJD    OBJ(&DPLIB/UDC*) OBJTYPE(*DTAARA) +
                          OUTPUT(*OUTFILE) OUTFILE(QTEMP/DTAFILE)                         /*CPK015*/
/* */
/*       Check for no objects                                        */
/* */
             MONMSG     MSGID(CPF2105 CPF2123) EXEC(GOTO CMDLBL(NEXT))
/* */
/*       Perform override                                            */
/* */
             OVRDBF     FILE(QADSPOBJ) TOFILE(QTEMP/DTAFILE)
/* */
 READ:       RCVF
/* */
/*       Check for end of file                                       */
/* */
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(NEXT))
/* */
/*       Delete data area if it is 'Allocation dataarea'             */
/* */
/************DLTDTAARA  DTAARA(&DILIB/&ODOBNM)                                         */ /*CPK015*/
             DLTDTAARA  DTAARA(&ODLBNM/&ODOBNM)                                           /*CPK015*/
/* */
             GOTO CMDLBL(READ)
/* */
/**Delete*Data*queue*CGALLOC*in*the*DILIB**/                                              /*CPK015*/
/* */
/**********                                  */                                           /*CPK015*/
/*NEXT:****  DLTDTAQ    DTAQ(&DILIB/CGALLOC) */                                           /*CPK015*/
/**********  MONMSG     MSGID(CPF2105)       */                                           /*CPK015*/
                                                                                          /*CPK015*/
/* Clear DTAQ CGALLOC */                                                                  /*CPK015*/
                                                                                          /*CPK015*/
 NEXT:                                                                                    /*CPK015*/
             CALL       PGM(QCLRDTAQ) PARM('CGALLOC' '*LIBL ')                            /*CPK015*/
                                                                                          /*CPK015*/
/* */
/* Delete Members from CGPGEN* Files */
/* */
/*/COPY WNCPYSRC,CGC8110003                                          */
             RMVM       FILE(CGPGENL0) MBR(*ALL)
             MONMSG     MSGID(CPF7301)
             RMVM       FILE(CGPGENL1) MBR(*ALL)
             MONMSG     MSGID(CPF7301)
             RMVM       FILE(CGPGENL2) MBR(*ALL)
             MONMSG     MSGID(CPF7301)
             RMVM       FILE(CGPGENL3) MBR(*ALL)
             MONMSG     MSGID(CPF7301)
             RMVM       FILE(CGPGENL4) MBR(*ALL)                      /*087936*/
             MONMSG     MSGID(CPF7301)                                /*087936*/
             RMVM       FILE(CGPGENPD) MBR(*ALL)
             MONMSG     MSGID(CPF7301)
/* */
/* Add one member to allocation when starting to journal */
/* */
             ADDPFM     FILE(CGPGENPD) MBR(CGPGENPF) TEXT('User +
                          Defined Correspondence')
/* */
/**Delete*the*route*folder*for*the*print*generator**/                 /*134481*/
/* Retrieve the print generator folder name if available,  */         /*134481*/
/* else set up folder name.                                */         /*134481*/
/* */
             RTVDTAARA  DTAARA(CGDTA (7 10)) RTNVAR(&FOLDER)
             RTVDTAARA  DTAARA(CGDTA (9 8)) RTNVAR(&FOLDER_8)         /*134481*/
                                                                      /*134481*/
/************IF         COND(&FOLDER *EQ '        ') THEN(DO)      */ /*134481*/
             IF         COND(&FOLDER_8 *NE '        ') THEN(DO)       /*134481*/
             CHGVAR     VAR(&FOLDER) VALUE(&DBPREFIX *CAT &FOLDER_8)
             ENDDO                                                    /*134481*/
             ELSE       CMD(DO)                                       /*134481*/
             CHGVAR     VAR(&FOLDER) VALUE(&DBPREFIX *CAT 'FILE.DTA') /*134481*/
             ENDDO
/* */
/* Delete the route folder for the print generator */                 /*134481*/
/* */
             DLTDLO     DLO(*ALL) FLR(&FOLDER)
             MONMSG     MSGID(CPF8A16)
/* */
/* Create New folder for next day */
/* */
/************RTVDTAARA  DTAARA(CGDTA (9 8)) RTNVAR(&FOLDER_8)      */ /*134481*/
/************IF         COND(&FOLDER_8 *NE '        ') THEN(DO)    */ /*134481*/
/************CHGVAR     VAR(&FOLDER) VALUE(&DBPREFIX *CAT &FOLDER_8)/ /*134481*/
/************ENDDO                                                 */ /*134481*/
/************ELSE       CMD(DO)                                    */ /*134481*/
/************CHGVAR     VAR(&FOLDER) VALUE(&DBPREFIX *CAT 'FILE.DTA') /*134481*/
/************ENDDO                                                 */ /*134481*/
/* */
             CRTFLR     FLR(&FOLDER) TEXT('User Defined +
                          Correspondence Stream Files') AUT(*ALL)
/* */
             CHGDTAARA  DTAARA(CGDTA (7 10)) VALUE(&FOLDER)
/* */                                                                 /*089168*/
/* Set up folders for bulk jobs */                                    /*089168*/
/* */                                                                 /*089168*/
             CHGVAR     VAR(%SST(&FOLDER 6 1)) VALUE('1')             /*089168*/
             DLTDLO     DLO(*ALL) FLR(&FOLDER)                        /*089168*/
             MONMSG     MSGID(CPF8A16)                                /*089168*/
             CRTFLR     FLR(&FOLDER) TEXT('U.D.C.Stream Files Bulk +
                          job 1') AUT(*ALL)                           /*089168*/
             CHGVAR     VAR(%SST(&FOLDER 6 1)) VALUE('2')             /*089168*/
             DLTDLO     DLO(*ALL) FLR(&FOLDER)                        /*089168*/
             MONMSG     MSGID(CPF8A16)                                /*089168*/
             CRTFLR     FLR(&FOLDER) TEXT('U.D.C.Stream Files Bulk +
                          job 1') AUT(*ALL)                           /*089168*/
             CHGVAR     VAR(%SST(&FOLDER 6 1)) VALUE('3')             /*089168*/
             DLTDLO     DLO(*ALL) FLR(&FOLDER)                        /*089168*/
             MONMSG     MSGID(CPF8A16)                                /*089168*/
             CRTFLR     FLR(&FOLDER) TEXT('U.D.C.Stream Files Bulk +
                          job 1') AUT(*ALL)                           /*089168*/
             CHGVAR     VAR(%SST(&FOLDER 6 1)) VALUE('4')             /*089168*/
             DLTDLO     DLO(*ALL) FLR(&FOLDER)                        /*089168*/
             MONMSG     MSGID(CPF8A16)                                /*089168*/
             CRTFLR     FLR(&FOLDER) TEXT('U.D.C.Stream Files Bulk +
                          job 1') AUT(*ALL)                           /*089168*/
             CHGVAR     VAR(%SST(&FOLDER 6 1)) VALUE('5')             /*089168*/
             DLTDLO     DLO(*ALL) FLR(&FOLDER)                        /*089168*/
             MONMSG     MSGID(CPF8A16)                                /*089168*/
             CRTFLR     FLR(&FOLDER) TEXT('U.D.C.Stream Files Bulk +
                          job 1') AUT(*ALL)                           /*089168*/
             CHGVAR     VAR(%SST(&FOLDER 6 1)) VALUE('6')             /*089168*/
             DLTDLO     DLO(*ALL) FLR(&FOLDER)                        /*089168*/
             MONMSG     MSGID(CPF8A16)                                /*089168*/
             CRTFLR     FLR(&FOLDER) TEXT('U.D.C.Stream Files Bulk +
                          job 1') AUT(*ALL)                           /*089168*/
             CHGDTAARA  DTAARA(CGDTA (112 3)) VALUE('000')            /*089167*/
/* */
/* Update status to Not Active - component finished */
/* */
             CHGVAR     VAR(&STATUS) VALUE('N')
             CALL       PGM(CB0150) PARM(&COMP_NAME &COMP_SEQ &STATUS)
/**/
             GOTO       CMDLBL(ENDCLPGM)
/* */
/* Report Database errors trapped by program */
/* */
 DBERR:
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
/**/
/* Abnormal termination processing                       */
/**/
ABNORMAL:
             ROLLBACK
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program CGC8110 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          CGC8110 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDCLPGM:   RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/* */
             ENDPGM
