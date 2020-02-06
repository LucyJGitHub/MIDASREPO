/*********************************************************************/
/*XBI    OVRDBF FILE(UPC0261DFD) TOFILE(QAFDPHY)                     */
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas UP Display objects not moved')                  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Upgrade Module                                      */
/*                                                                   */
/*       UPC0261 - Display objects not moved                         */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. CUT008              Date 09Feb11             */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CPK025  *MOVED     Date 03Jul06              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CPK015             Date 27May02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CUP015 *CREATE     Date 02Jul01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CUT008  - CRTOBJ rewrite.                                   */
/*                 Change of CRTOBJ parameters.                      */
/*       CPK025 - MidasPlus 1.3 packaging.  Moved to global layer.   */
/*                Handle SQL objects and global layer.               */
/*       CPK015 - 4.01 packaging.  Handle data queues.               */
/*       CUP015 -  Processing moved from RPG to CL                   */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&OPTION &OBJECT &FROMLIB &TOLIB +
                          &OBJATR &OBJTYPE &SRCLIB &SRCFILE &RETURNCODE)
 
             DCL        VAR(&OPTION) TYPE(*CHAR) LEN(1)
             DCL        VAR(&OBJECT) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FROMLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TOLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OBJATR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OBJTYPE) TYPE(*CHAR) LEN(8)
             DCL        VAR(&SRCLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SRCFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RETURNCODE) TYPE(*CHAR) LEN(10)
 
             DCL        VAR(&MEMBER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CHECKLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             DCLF       FILE(UPC0261DFD)
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Process requests */
             CHGVAR     VAR(&RETURNCODE) VALUE('          ')
             IF         COND(&OPTION *EQ 'O') THEN(GOTO CMDLBL(ObjDescr))
             IF         COND(&OPTION *EQ 'V') THEN(GOTO CMDLBL(View))
             IF         COND(&OPTION *EQ 'X') THEN(GOTO CMDLBL(Copy))
 
             GOTO       CMDLBL(ENDPGM)
 
ObjDescr:
             DSPOBJD    OBJ(&FROMLIB/&OBJECT) OBJTYPE(&OBJTYPE)
 
             GOTO       CMDLBL(ENDPGM)
 
View:
             IF         COND(&OBJTYPE *EQ '*FILE') THEN(DO)
                IF         COND(&OBJATR *EQ 'PF') THEN(DO)
                   DSPPFM     FILE(&FROMLIB/&OBJECT)
                ENDDO
 
                ELSE       CMD(DO)
                   DSPFD       FILE(&FROMLIB/&OBJECT)
                ENDDO
 
             ENDDO
 
             IF         COND(&OBJATR *EQ 'DTAARA') THEN(DO)
                DSPDTAARA  DTAARA(&FROMLIB/&OBJECT)
             ENDDO
 
             IF         COND(&OBJATR *EQ 'MSGF') THEN(DO)
                DSPMSGF   MSGF(&FROMLIB/&OBJECT) OUTPUT(*)
             ENDDO
 
             IF         COND(&OBJTYPE *EQ '*PGM') THEN(DO)
                DSPPGM     PGM(&FROMLIB/&OBJECT) OUTPUT(*)
             ENDDO
 
             IF         COND(&OBJTYPE *EQ '*MODULE') THEN(DO)
                DSPMOD     MODULE(&FROMLIB/&OBJECT) OUTPUT(*)
             ENDDO
 
             IF         COND(&OBJTYPE *EQ '*SRVPGM') THEN(DO)
                DSPSRVPGM  SRVPGM(&FROMLIB/&OBJECT) OUTPUT(*)
             ENDDO
 
             GOTO       CMDLBL(ENDPGM)
 
Copy:
 
/* First check that the object has not been moved to a different  */
/* (Core) library.                                                */
/* Check global layer first. */                                                           /*CPK025*/
             IF         COND(%SST(&FROMLIB 3 1) *EQ 'G') THEN(DO)                         /*CPK025*/
                CHGVAR     VAR(&RETURNCODE) VALUE(Precheck)                               /*CPK025*/
                CHGVAR     VAR(&CHECKLIB) VALUE(%SST(&TOLIB 1 2) *CAT +
                             'GXLIB')                                                     /*CPK025*/
                CHKOBJ     OBJ(&CHECKLIB/&OBJECT) OBJTYPE(&OBJTYPE)                       /*CPK025*/
 
                MONMSG     MSGID(CPF9801 CPF9810) EXEC(DO)                                /*CPK025*/
                   CHGVAR     VAR(&CHECKLIB) VALUE(%SST(&TOLIB 1 2) *CAT +
                                'GVLIB')                                                  /*CPK025*/
                   CHKOBJ     OBJ(&CHECKLIB/&OBJECT) OBJTYPE(&OBJTYPE)                    /*CPK025*/
 
                   MONMSG     MSGID(CPF9801 CPF9810) EXEC(DO)                             /*CPK025*/
                      CHGVAR     VAR(&CHECKLIB) VALUE(%SST(&TOLIB 1 2) *CAT +
                                   'GPLIB')                                               /*CPK025*/
                      CHKOBJ     OBJ(&CHECKLIB/&OBJECT) OBJTYPE(&OBJTYPE)                 /*CPK025*/
 
                      MONMSG     MSGID(CPF9801 CPF9810) EXEC(DO)                          /*CPK025*/
                         CHGVAR     VAR(&CHECKLIB) VALUE(%SST(&TOLIB 1 2) *CAT +
                                      'GMLIB')                                            /*CPK025*/
                         CHKOBJ     OBJ(&CHECKLIB/&OBJECT) OBJTYPE(&OBJTYPE)              /*CPK025*/
 
                         MONMSG     MSGID(CPF9801 CPF9810) EXEC(DO)                       /*CPK025*/
                            CHGVAR     VAR(&CHECKLIB) VALUE(%SST(&TOLIB 1 2) *CAT +
                                         'GTALIB')                                        /*CPK025*/
                            CHKOBJ     OBJ(&CHECKLIB/&OBJECT) OBJTYPE(&OBJTYPE)           /*CPK025*/
 
                            MONMSG     MSGID(CPF9801 CPF9810) EXEC(DO)                    /*CPK025*/
                               CHGVAR     VAR(&RETURNCODE) VALUE('          ')            /*CPK025*/
                            ENDDO                                                         /*CPK025*/
                         ENDDO                                                            /*CPK025*/
                      ENDDO                                                               /*CPK025*/
                   ENDDO                                                                  /*CPK025*/
                ENDDO                                                                     /*CPK025*/
             ENDDO                                                                        /*CPK025*/
 
/* Check zone second. */                                                                  /*CPK025*/
             IF         COND(%SST(&FROMLIB 3 1) *EQ 'D') THEN(DO)                         /*CPK025*/
                CHGVAR     VAR(&RETURNCODE) VALUE(Precheck)
                CHGVAR     VAR(&CHECKLIB) VALUE(%SST(&TOLIB 1 2) *CAT +
                             'XLIB')
                CHKOBJ     OBJ(&CHECKLIB/&OBJECT) OBJTYPE(&OBJTYPE)
 
                MONMSG     MSGID(CPF9801 CPF9810) EXEC(DO)
                   CHGVAR     VAR(&CHECKLIB) VALUE(%SST(&TOLIB 1 2) *CAT +
                                'DVLIB')
                   CHKOBJ     OBJ(&CHECKLIB/&OBJECT) OBJTYPE(&OBJTYPE)
 
                   MONMSG     MSGID(CPF9801 CPF9810) EXEC(DO)
                      CHGVAR     VAR(&CHECKLIB) VALUE(%SST(&TOLIB 1 2) *CAT +
                                   'DPLIB')
                      CHKOBJ     OBJ(&CHECKLIB/&OBJECT) OBJTYPE(&OBJTYPE)
 
                      MONMSG     MSGID(CPF9801 CPF9810) EXEC(DO)
                         CHGVAR     VAR(&CHECKLIB) VALUE(%SST(&TOLIB 1 2) *CAT +
                                      'DMLIB')
                         CHKOBJ     OBJ(&CHECKLIB/&OBJECT) OBJTYPE(&OBJTYPE)
 
                         MONMSG     MSGID(CPF9801 CPF9810) EXEC(DO)
                            CHGVAR     VAR(&CHECKLIB) VALUE(%SST(&TOLIB 1 2) *CAT +
                                         'DTALIB')
                            CHKOBJ     OBJ(&CHECKLIB/&OBJECT) OBJTYPE(&OBJTYPE)
 
                            MONMSG     MSGID(CPF9801 CPF9810) EXEC(DO)
                               CHGVAR     VAR(&RETURNCODE) VALUE('          ')
                            ENDDO
                         ENDDO
                      ENDDO
                   ENDDO
                ENDDO
             ENDDO                                                                        /*CPK025*/
 
/* If object found in 'to' system....  */
             IF         COND(&RETURNCODE *NE '          ') THEN(DO)
                CHGDTAARA  DTAARA(MIDASMSG *ALL) VALUE(' ')
 
/* PF and data areas - send message then copy object           */
/************   IF         COND(%SST(&OBJATR 1 2) *EQ 'PF' *OR &OBJATR +               */ /*CPK015*/
/************                *EQ DTAARA) THEN(DO)                                      */ /*CPK015*/
                IF         COND(%SST(&OBJATR 1 2) *EQ 'PF') THEN(DO)                      /*CPK015*/
 
/* Message for files..  */
/************      IF         COND(%SST(&OBJATR 1 2) *EQ 'PF') THEN(DO)                */ /*CPK015*/
                   CHGVAR     VAR(&MESSAGE) VALUE('File ' *CAT &OBJECT +
                                *BCAT 'already exists in ' *CAT &CHECKLIB)
                   CALL       PGM(UTC0069) PARM(&MESSAGE X'00050F')
                   CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE(&MESSAGE)
                   CHGVAR     VAR(&MESSAGE) VALUE('Data in file ' *CAT +
                          &OBJECT *BCAT 'will be copied to ' *CAT +
                          &CHECKLIB)
                   CALL       PGM(UTC0069) PARM(&MESSAGE X'00050F')
                   CHGDTAARA  DTAARA(MIDASMSG (201 50)) VALUE(&MESSAGE)
                ENDDO
/************      ELSE       CMD(DO)                                                  */ /*CPK015*/
 
                IF         COND(&OBJATR *EQ 'DTAARA') THEN(DO)                            /*CPK015*/
/* Message for data areas..  */
                   CHGVAR     VAR(&MESSAGE) VALUE('Data area ' *CAT +
                                &OBJECT *BCAT 'already exists in ' *CAT +
                                &CHECKLIB)
                   CALL       PGM(UTC0069) PARM(&MESSAGE X'00050F')
                   CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE(&MESSAGE)
                   CHGVAR     VAR(&MESSAGE) VALUE('Data area ' *CAT +
                       &FROMLIB *TCAT '/' *CAT &OBJECT *BCAT +
                       'will be copied to ')
                   CALL       PGM(UTC0069) PARM(&MESSAGE X'00050F')
                   CHGDTAARA  DTAARA(MIDASMSG (201 50)) VALUE(&MESSAGE)
                   CHGVAR     VAR(&MESSAGE) VALUE(&CHECKLIB)
                   CALL       PGM(UTC0069) PARM(&MESSAGE X'00050F')
                   CHGDTAARA  DTAARA(MIDASMSG (251 50)) VALUE(&MESSAGE)
                ENDDO
 
/* Data queues - send message. */                                                         /*CPK015*/
                IF         COND(&OBJATR *EQ 'DTAQ') THEN(DO)                              /*CPK015*/
                   CHGVAR     VAR(&MESSAGE) VALUE('Data queue ' *CAT +
                                &OBJECT *BCAT 'already exists in ' *CAT +
                                &CHECKLIB)                                                /*CPK015*/
                   CALL       PGM(UTC0069) PARM(&MESSAGE X'00050F')                       /*CPK015*/
                   CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE(&MESSAGE)
                   CHGVAR     VAR(&MESSAGE) VALUE('Data queue ' *CAT +
                                &FROMLIB *TCAT '/' *CAT &OBJECT *BCAT +
                                'will be copied to ')                                     /*CPK015*/
                   CALL       PGM(UTC0069) PARM(&MESSAGE X'00050F')                       /*CPK015*/
                   CHGDTAARA  DTAARA(MIDASMSG (201 50)) VALUE(&MESSAGE)                   /*CPK015*/
                   CHGVAR     VAR(&MESSAGE) VALUE(&CHECKLIB)                              /*CPK015*/
                   CALL       PGM(UTC0069) PARM(&MESSAGE X'00050F')                       /*CPK015*/
                   CHGDTAARA  DTAARA(MIDASMSG (251 50)) VALUE(&MESSAGE)                   /*CPK015*/
                ENDDO                                                                     /*CPK015*/
 
                CALL       PGM(SCC0010) PARM('UPC0261' 'ENTER' ' ')
 
/* Attempt to copy file.  */
                IF         COND(%SST(&OBJATR 1 2) *EQ 'PF') THEN(DO)
                   CPYF       FROMFILE(&FROMLIB/&OBJECT) +
                                TOFILE(&CHECKLIB/&OBJECT) FROMMBR(*ALL) +
                                TOMBR(*FROMMBR) MBROPT(*REPLACE) +
                                FMTOPT(*MAP *DROP)
 
/* If from-file has no members or its only member is empty,  */
/* ignore it.                                                */
                   MONMSG     MSGID(CPF2817) CMPDTA(CPF2868)
                   MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
                   MONMSG     MSGID(CPF2817) CMPDTA(CPF2870)
 
/* If to-file has insufficient allowed number of members,    */
/* change to-file.                                           */
                   MONMSG     MSGID(CPF2888) EXEC(DO)
                      DSPFD      FILE(&FROMLIB/&OBJECT) TYPE(*ATR) +
                                   OUTPUT(*OUTFILE) FILEATR(*PF) +
                                   OUTFILE(QTEMP/UPC0261DFD)
                      RCVF
                      IF         COND(&PHMAXM *EQ 0) THEN(CHGVAR VAR(&PHMAXM) +
                          VALUE(32767))
                      CHGPF      FILE(&CHECKLIB/&OBJECT) MAXMBRS(&PHMAXM)
                      CPYF       FROMFILE(&FROMLIB/&OBJECT) +
                                   TOFILE(&CHECKLIB/&OBJECT) FROMMBR(*ALL) +
                                   TOMBR(*FROMMBR) MBROPT(*REPLACE) +
                                   FMTOPT(*MAP *DROP)
 
/* If member mismatch (ie from-file has a set number of members */
/* but these members are different to the to-file members),     */
/* send message and abort.                                      */
                      MONMSG     MSGID(CPF2888) EXEC(DO)
                         CHGVAR     VAR(&MESSAGE) VALUE('File ' *CAT &OBJECT +
                                      *BCAT 'has a member mismatch - some members')
                         CALL       PGM(UTC0069) PARM(&MESSAGE X'00050F')
                         CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE(&MESSAGE)
                         CHGVAR     VAR(&MESSAGE) VALUE('have not been copied.  +
                          Check joblog for details.')
                         CALL       PGM(UTC0069) PARM(&MESSAGE X'00050F')
                         CHGDTAARA  DTAARA(MIDASMSG (151 50)) VALUE(&MESSAGE)
                         CALL       PGM(SCC0010) PARM('UPC0261' 'JOBLOG' 'Y')
                         CHGVAR     VAR(&RETURNCODE) VALUE('Error')
                         GOTO       CMDLBL(ENDPGM)
                      ENDDO
                   ENDDO
                   CHGVAR     VAR(&RETURNCODE) VALUE('Exist     ')
                   GOTO       CMDLBL(ENDPGM)
                ENDDO
 
/* Copy data area.  */
/***********       ELSE       CMD(DO)                                                  */ /*CPK015*/
                IF         COND(&OBJATR *EQ 'DTAARA') THEN(DO)                            /*CPK015*/
                   CPYDTAARA  FMDTAARA(&FROMLIB/&OBJECT) +
                       TODTAARA(&CHECKLIB/&OBJECT)
                   CHGVAR     VAR(&RETURNCODE) VALUE('Exist     ')
                   GOTO       CMDLBL(ENDPGM)
                ENDDO
 
/* Copy data queue.  */
                IF         COND(&OBJATR *EQ 'DTAQ') THEN(DO)                              /*CPK015*/
                   CPYDTAQ    FMDTAQ(&FROMLIB/&OBJECT) +
                                TODTAQ(&CHECKLIB/&OBJECT)                                 /*CPK015*/
                   CHGVAR     VAR(&RETURNCODE) VALUE('Exist     ')                        /*CPK015*/
                   GOTO       CMDLBL(ENDPGM)                                              /*CPK015*/
                ENDDO                                                                     /*CPK015*/
 
/************ENDDO                                                                     */ /*CPK015*/
 
/* Any other object - send message then continue (no copy)    */
                CHGVAR     VAR(&MESSAGE) VALUE('Object ' *CAT &OBJECT +
                          *BCAT 'type ' *CAT &OBJTYPE *BCAT +
                          'already exists in ')
                CALL       PGM(UTC0069) PARM(&MESSAGE X'00050F')
                CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE(&MESSAGE)
                CHGVAR     VAR(&MESSAGE) VALUE(&CHECKLIB)
                CALL       PGM(UTC0069) PARM(&MESSAGE X'00050F')
                CHGDTAARA  DTAARA(MIDASMSG (151 50)) VALUE(&MESSAGE)
                CHGVAR     VAR(&MESSAGE) VALUE(&OBJECT *BCAT 'will NOT +
                             be copied to ' *CAT &TOLIB)
                CALL       PGM(UTC0069) PARM(&MESSAGE X'00050F')
                CHGDTAARA  DTAARA(MIDASMSG (301 50)) VALUE(&MESSAGE)
                CALL       PGM(SCC0010) PARM('UPC0261' 'ENTER' ' ')
                CHGVAR     VAR(&RETURNCODE) VALUE('Exist     ')
                GOTO       CMDLBL(ENDPGM)
 
             ENDDO
 
/* Object not found - use appropriate command to copy it.    */
             IF         COND(&OBJATR *EQ 'PF') THEN(DO)
                CRTDUPOBJ  OBJ(&OBJECT) FROMLIB(&FROMLIB) +
                          OBJTYPE(&OBJTYPE) TOLIB(&TOLIB) DATA(*YES)
                CHGVAR     VAR(&RETURNCODE) VALUE('*CHECK')
             ENDDO
 
             IF         COND(&OBJATR *EQ 'LF') THEN(DO)
/**********     ?          CRTOBJ SRCMBR(&OBJECT) +                                    */ /*CUT008*/
/**********               SRCFILE(&SRCLIB/&SRCFILE) PLIB(&TOLIB)                       */ /*CUT008*/
                ?          CRTOBJ OBJ(&TOLIB/&OBJECT) +
                             SRCFILE(&SRCLIB/&SRCFILE) SRCMBR(*OBJ)                       /*CUT008*/
                MONMSG     MSGID(CPF6801) EXEC(GOTO CMDLBL(ENDPGM))
                CHGVAR     VAR(&RETURNCODE) VALUE('*CHECK')
             ENDDO
 
             IF         COND(&OBJATR *EQ 'DTAQ') THEN(DO)
/************   DLTF       FILE(QTEMP/UP0261SF)                                        */ /*CPK015*/
/************   MONMSG     MSGID(CPF0000)                                              */ /*CPK015*/
/************   CRTSAVF    FILE(QTEMP/UP0261SF) TEXT('Midas UP Save file')             */ /*CPK015*/
/************   SAVOBJ     OBJ(&OBJECT) LIB(&FROMLIB) DEV(*SAVF) +                     */ /*CPK015*/
/************             OBJTYPE(*DTAQ) SAVF(QTEMP/UP0261SF)                          */ /*CPK015*/
/************   RSTOBJ     OBJ(&OBJECT) SAVLIB(&FROMLIB) DEV(*SAVF) +                  */ /*CPK015*/
/************             OBJTYPE(*DTAQ) SAVF(QTEMP/UP0261SF) +                        */ /*CPK015*/
/************             RSTLIB(&TOLIB)                                               */ /*CPK015*/
                CPYDTAQ    FMDTAQ(&FROMLIB/&OBJECT) +
                             TODTAQ(&TOLIB/&OBJECT) CRTDTAQ(*YES)                         /*CPK015*/
                CHGVAR     VAR(&RETURNCODE) VALUE('*CHECK')
             ENDDO
 
/* Any other object - use CRTDUPOBJ */
 
             IF         COND(&RETURNCODE *EQ '*CHECK') THEN(GOTO +
                          CMDLBL(CHKOBJ))
             CRTDUPOBJ  OBJ(&OBJECT) FROMLIB(&FROMLIB) +
                          OBJTYPE(&OBJTYPE) TOLIB(&TOLIB)
CHKOBJ:
             CALL       PGM(UTCHKOBJ) PARM(&RETURNCODE &OBJECT +
                          &TOLIB &OBJTYPE &MEMBER)
 
             GOTO       CMDLBL(ENDPGM)
 
ABNOR:
             CHGVAR     VAR(&RETURNCODE) VALUE('Error')
             RTVMSG     MSGID(UPM0001) MSGF(UTMSGF) +
                          MSGDTA('UPC0261') MSG(&MESSAGE)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE(&MESSAGE)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(MIDASMSG (201 50)) VALUE('Check +
                          joblog for details')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(SCC0010) PARM('UPC0261' 'JOBLOG' 'Y')
             MONMSG     MSGID(CPF0000)
 
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
