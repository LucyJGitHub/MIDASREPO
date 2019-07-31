/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas UP Compare two output queues')                  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Upgrade Module                                      */
/*                                                                   */
/*       UPC0400 - Compare two output queues                         */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CUP039             Date 25Mar11              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.04 ---------------------------------------------------*/
/*                      CUP012 *C *CREATE  Date 07Aug00              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CUP039 - Spool file number changed from length 4 to 6.      */
/*       CUP012 - Creation of CMPOUTQ command.  This is a re-write   */
/*                 of CMPCOB.                                        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&OUTQ1 &OUTQ2 &LIN &COLDIF &MOVLIN)
 
             DCL        VAR(&OUTQ1) TYPE(*CHAR) LEN(20)
             DCL        VAR(&OUTQ2) TYPE(*CHAR) LEN(20)
             DCL        VAR(&LIN) TYPE(*DEC) LEN(1)
             DCL        VAR(&COLDIF) TYPE(*CHAR) LEN(4)
             DCL        VAR(&MOVLIN) TYPE(*CHAR) LEN(4)
 
             DCL        VAR(&OUTQUEUE1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OUTQLIB1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OUTQUEUE2) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OUTQLIB2) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TXT) TYPE(*CHAR) LEN(30)
             DCL        VAR(&TITLE) TYPE(*CHAR) LEN(80)
             DCL        VAR(&TITLE2) TYPE(*CHAR) LEN(100)
             DCL        VAR(&REPDESC) TYPE(*CHAR) LEN(80)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             DCLF       FILE(UPCCMMQF)
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Create data area /MIDASMSG in QTEMP */
             DLTDTAARA  DTAARA(QTEMP/MIDASMSG)
             MONMSG     MSGID(CPF0000)
             CRTDTAARA  DTAARA(QTEMP/MIDASMSG) TYPE(*CHAR) LEN(800) +
                          VALUE(' ')
 
/* Create outfile used for CMPPFM. */                                                     /*CUP039*/
             DLTF       FILE(QTEMP/UPCMPSOF)                                              /*CUP039*/
             MONMSG     MSGID(CPF0000)                                                    /*CUP039*/
             CRTPF      FILE(QTEMP/UPCMPSOF) RCDLEN(220) SIZE(*NOMAX)                     /*CUP039*/
 
             CHGVAR     VAR(&OUTQUEUE1) VALUE(%SST(&OUTQ1 1 10))
             CHGVAR     VAR(&OUTQLIB1) VALUE(%SST(&OUTQ1 11 10))
             CHGVAR     VAR(&OUTQUEUE2) VALUE(%SST(&OUTQ2 1 10))
             CHGVAR     VAR(&OUTQLIB2) VALUE(%SST(&OUTQ2 11 10))
 
             IF         COND(&OUTQLIB1 *EQ '*LIBL') THEN(DO)
                RTVOBJD    OBJ(&OUTQUEUE1) OBJTYPE(*OUTQ) +
                          RTNLIB(&OUTQLIB1)
             ENDDO
             IF         COND(&OUTQLIB2 *EQ '*LIBL') THEN(DO)
                RTVOBJD    OBJ(&OUTQUEUE2) OBJTYPE(*OUTQ) +
                          RTNLIB(&OUTQLIB2)
             ENDDO
 
/* Use CVTOUTQ command to put contents of output queue into physical file */
             DLTF       FILE(QTEMP/OUTQP)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(QTEMP/OUTQP2)
             MONMSG     MSGID(CPF0000)
             CPYF       FROMFILE(UTCVOQPD) TOFILE(QTEMP/OUTQP) +
                          TOMBR(M1) CRTFILE(*YES)
             CHGPF      FILE(QTEMP/OUTQP) MAXMBRS(4) SIZE(*NOMAX)
 
             CVTOUTQ    OUTQ(&OUTQLIB1/&OUTQUEUE1) OUTLIB(QTEMP) OUTMBR(M1)
             MONMSG     MSGID(CPF0000) EXEC(DO)
                SNDMSG     MSG('Error found in parameter 1 for +
                          CVTOUTQ') TOUSR(*REQUESTER)
                GOTO       CMDLBL(END)
             ENDDO
 
             CVTOUTQ    OUTQ(&OUTQLIB2/&OUTQUEUE2) OUTLIB(QTEMP) OUTMBR(M2)
             MONMSG     MSGID(CPF0000) EXEC(DO)
                SNDMSG     MSG('Error found in parameter 2 for +
                          CVTOUTQ') TOUSR(*REQUESTER)
                GOTO       CMDLBL(END)
             ENDDO
 
/* If identical job names in the output queue, arrange sequence number */
             OPNQRYF    FILE((QTEMP/OUTQP M1)) OPTION(*ALL) +
                          KEYFLD((SPJNAM *ASCEND) (SPFILE *ASCEND) +
                          (SPJNBR *ASCEND))
             OVRDBF     FILE(OUTQP) MBR(M1) SHARE(*YES)
             CALL       PGM(UP0415)
             CLOF       OPNID(OUTQP)
             DLTOVR     FILE(*ALL)
 
             OPNQRYF    FILE((QTEMP/OUTQP M2)) OPTION(*ALL) +
                          KEYFLD((SPJNAM *ASCEND) (SPFILE *ASCEND) +
                          (SPJNBR *ASCEND))
             OVRDBF     FILE(OUTQP) MBR(M2) SHARE(*YES)
             CALL       PGM(UP0415)
             CLOF       OPNID(OUTQP)
             DLTOVR     FILE(*ALL)
 
/* Produce reports of files found in one output queue but not other */
             OVRDBF     FILE(UPCCOBQF) TOFILE(OUTQP) SHARE(*YES)
             OPNQRYF    FILE((OUTQP M1) (OUTQP M2)) FORMAT(UPCCOBQF) +
                          JFLD((1/SPFILE 2/SPFILE *EQ) (1/SPJNAM +
                          2/SPJNAM) (1/SPFNBR 2/SPFNBR) (1/SPNREC +
                          2/SPNREC)) JDFTVAL(*ONLYDFT) +
                          JORDER(*FILE) MAPFLD((CCSYS '1/SPSYS') +
                          (CCOUTQ '1/SPOUTQ') (CCOQLB '1/SPOQLB') +
                          (CCFILE '1/SPFILE') (CCFNBR '1/SPFNBR') +
                          (CCUSER '1/SPUSER') (CCUDTA '1/SPUDTA') +
                          (CCJNAM '1/SPJNAM') (CCJNBR '1/SPJNBR') +
                          (CCNREC '1/SPNREC'))
 
/* Use a new file to avoid problems in OPNQRYF (otherwise it gets  */
/* confused as to which record format it is using).                */
             CPYFRMQRYF FROMOPNID(OUTQP) TOFILE(QTEMP/OUTQP2) +
                          TOMBR(M1) MBROPT(*REPLACE) CRTFILE(*YES)
             OVRDBF     FILE(UPCCOBQF) TOFILE(OUTQP2) MBR(M1) +
                          SHARE(*YES)
             CHGVAR     VAR(&TITLE) VALUE('Spool files in outq' +
                          *BCAT &OUTQLIB1 *TCAT '/' *TCAT &OUTQUEUE1 *BCAT +
                          'but not in' *BCAT &OUTQLIB2 *TCAT '/' *TCAT +
                          &OUTQUEUE2)
             CALL       PGM(UP0402) PARM(&TITLE)
             DLTOVR     FILE(UPCCOBQF)
             CLOF       OPNID(OUTQP)
 
             OVRDBF     FILE(UPCCOBQF) TOFILE(OUTQP) SHARE(*YES)
             OPNQRYF    FILE((OUTQP M2) (OUTQP M1)) FORMAT(UPCCOBQF) +
                          JFLD((1/SPFILE 2/SPFILE *EQ) (1/SPJNAM +
                          2/SPJNAM) (1/SPFNBR 2/SPFNBR) (1/SPNREC +
                          2/SPNREC)) JDFTVAL(*ONLYDFT) +
                          JORDER(*FILE) MAPFLD((CCSYS '1/SPSYS') +
                          (CCOUTQ '1/SPOUTQ') (CCOQLB '1/SPOQLB') +
                          (CCFILE '1/SPFILE') (CCFNBR '1/SPFNBR') +
                          (CCUSER '1/SPUSER') (CCUDTA '1/SPUDTA') +
                          (CCJNAM '1/SPJNAM') (CCJNBR '1/SPJNBR') +
                          (CCNREC '1/SPNREC'))
 
/* Use a new file to avoid problems in OPNQRYF (otherwise it gets  */
/* confused as to which record format it is using).                */
             CPYFRMQRYF FROMOPNID(OUTQP) TOFILE(QTEMP/OUTQP2) +
                          TOMBR(M2) MBROPT(*REPLACE)
             OVRDBF     FILE(UPCCOBQF) TOFILE(OUTQP2) MBR(M2) +
                          SHARE(*YES)
             CHGVAR     VAR(&TITLE) VALUE('Spool files in outq' +
                          *BCAT &OUTQLIB2 *TCAT '/' *TCAT &OUTQUEUE2 *BCAT +
                          'but not in' *BCAT &OUTQLIB1 *TCAT '/' *TCAT +
                          &OUTQUEUE1)
             CALL       PGM(UP0402) PARM(&TITLE)
             DLTOVR     FILE(UPCCOBQF)
             CLOF       OPNID(OUTQP)
 
/* Set up report title */
             CHGVAR     VAR(&TITLE2) VALUE('First output queue:' +
                          *BCAT &OUTQLIB1 *TCAT '/' *TCAT +
                          &OUTQUEUE1 *CAT '          Second output +
                          queue:' *BCAT &OUTQLIB2 *TCAT '/' *TCAT +
                          &OUTQUEUE2)
/* Set up file for processing matched spool files */
             OPNQRYF    FILE((OUTQP M1) (OUTQP M2)) FORMAT(UPCCMMQF) +
                          JFLD((1/SPFILE 2/SPFILE *EQ) (1/SPJNAM +
                          2/SPJNAM) (1/SPFNBR 2/SPFNBR) (1/SPNREC +
                          2/SPNREC)) JDFTVAL(*NO) JORDER(*FILE) +
                          MAPFLD((C1FILE '1/SPFILE') (C1JNBR +
                          '1/SPJNBR') (C1JNAM '1/SPJNAM') (C1USER +
                          '1/SPUSER') (C1FNBR '1/SPFNBR') (C1PRTX +
                          '1/SPPRTX') (C2FILE '2/SPFILE') (C2JNBR +
                          '2/SPJNBR') (C2JNAM '2/SPJNAM') (C2USER +
                          '2/SPUSER') (C2FNBR '2/SPFNBR') (C2PRTX +
                          '2/SPPRTX'))
             CPYFRMQRYF FROMOPNID(OUTQP) TOFILE(QTEMP/UPCCMMQF) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             OVRDBF     FILE(UPCCMMQF) TOFILE(QTEMP/UPCCMMQF)
 
             DLTF       FILE(QTEMP/UPJT01PD)
             MONMSG     MSGID(CPF0000)
             CPYF       FROMFILE(UPJT01PD) TOFILE(QTEMP/UPJT01PD) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             DLTF       FILE(QTEMP/UPJT02PD)
             MONMSG     MSGID(CPF0000)
             CPYF       FROMFILE(UPJT02PD) TOFILE(QTEMP/UPJT02PD) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
 
 LOOP:       RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(END))
 
/* Copy spool files to database files */
             IF         COND(&C1FILE *EQ 'QPJOBLOG') THEN(DO)                             /*CUP039*/
                GOTO       CMDLBL(LOOP)                                                   /*CUP039*/
             ENDDO                                                                        /*CUP039*/
             CPYSPLF    FILE(&C1FILE) TOFILE(QTEMP/UPJT01PD) +
                          JOB(&C1JNBR/&C1USER/&C1JNAM) SPLNBR(&C1FNBR)
 
             CPYSPLF    FILE(&C2FILE) TOFILE(QTEMP/UPJT02PD) +
                          JOB(&C2JNBR/&C2USER/&C2JNAM) SPLNBR(&C2FNBR)
 
/* If the spool file "print text" is not blank then copy it out */
             IF         COND(&C1PRTX *NE ' ') THEN(DO)
                CPYF       FROMFILE(QTEMP/UPJT01PD) +
                          TOFILE(QTEMP/UPNPT1QT) MBROPT(*REPLACE) +
                          CRTFILE(*YES) INCCHAR(JT1 52 *NE &C1PRTX)
                CPYF       FROMFILE(QTEMP/UPNPT1QT) +
                          TOFILE(QTEMP/UPJT01PD) MBROPT(*REPLACE)
             ENDDO
             IF         COND(&C2PRTX *NE ' ') THEN(DO)
                CPYF       FROMFILE(QTEMP/UPJT02PD) +
                          TOFILE(QTEMP/UPNPT2QT) MBROPT(*REPLACE) +
                          CRTFILE(*YES) INCCHAR(JT2 52 *NE &C2PRTX)
                CPYF       FROMFILE(QTEMP/UPNPT2QT) +
                          TOFILE(QTEMP/UPJT02PD) MBROPT(*REPLACE)
             ENDDO
 
/* If it has been requested to supress one or more lines from report */
/*  then run program to remove lines. */
             IF         COND(&LIN *NE 0) THEN(DO)
/* Copy the first file to a temporary copy (it may already exist) */
                CPYF       FROMFILE(QTEMP/UPJT01PD) +
                          TOFILE(QTEMP/UPJTNNQT) MBROPT(*REPLACE) +
                          CRTFILE(*YES)
                CALL       PGM(UP0400) PARM(&LIN)
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                   GOTO       CMDLBL(ABNOR)
                ENDDO
/* Copy the file back */
                CPYF       FROMFILE(QTEMP/UPJTNNQT) +
                          TOFILE(QTEMP/UPJT01PD) MBROPT(*REPLACE)
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(DO)
                   CLRPFM     FILE(QTEMP/UPJT01PD)
                ENDDO
/* Copy the second file with FMTOPT(*NOCHK) as the field name will be different */
                CPYF       FROMFILE(QTEMP/UPJT02PD) +
                          TOFILE(QTEMP/UPJTNNQT) MBROPT(*REPLACE) +
                          FMTOPT(*NOCHK)
                CALL       PGM(UP0400) PARM(&LIN)
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                   GOTO       CMDLBL(ABNOR)
                ENDDO
/* Copy the file back */
                CPYF       FROMFILE(QTEMP/UPJTNNQT) +
                          TOFILE(QTEMP/UPJT02PD) MBROPT(*REPLACE) +
                          FMTOPT(*NOCHK)
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(DO)
                   CLRPFM     FILE(QTEMP/UPJT02PD)
                ENDDO
             ENDDO
 
/* Set up report description */
             CHGVAR     VAR(&REPDESC) VALUE('Differences for +
                          reports:' *BCAT &C1JNAM *TCAT ',' *BCAT +
                          &C1FILE *BCAT &C1FNBR)
 
             CMPPFM     NEWFILE(QTEMP/UPJT01PD) NEWMBR(*FIRST) +
                          OLDFILE(QTEMP/UPJT02PD) OLDMBR(*FIRST) +
                          OUTPUT(*OUTFILE) OUTFILE(QTEMP/UPCMPSOF) +
                          OPTION(*LONGLINES)
 
             CHGJOB     SWS(0XXXXXXX)                                                     /*CUP039*/
             CALL       PGM(UP0401) PARM(&TITLE2 &REPDESC &COLDIF +
                          &MOVLIN)
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                GOTO       CMDLBL(ABNOR)
             ENDDO
             IF         COND(%SWITCH(1XXXXXXX)) THEN(DO)                                  /*CUP039*/
                CHGSPLFA   FILE(UP0401P1) SPLNBR(*LAST) SELECT(*CURRENT +
                             *ALL *ALL) USRDTA(&C1JNAM)                                   /*CUP039*/
             ENDDO                                                                        /*CUP039*/
 
             GOTO       CMDLBL(LOOP)
 
             GOTO       CMDLBL(END)
 ABNOR:
/* Set up messages for Midas Information Screen  */
             RTVMSG     MSGID(UPM0001) MSGF(UTMSGF) +
                          MSGDTA('UPC0400') MSG(&MESSAGE)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE(&MESSAGE)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(MIDASMSG (201 50)) VALUE('Check +
                          joblog for details')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(SCC0010) PARM('UPC0400' 'JOBLOG' 'Y')
             MONMSG     MSGID(CPF0000)
END:
             CLOF       OPNID(OUTQP)
             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(UPCCMMQF)
             MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
