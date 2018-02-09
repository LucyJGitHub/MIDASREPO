/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SF Insert/amend/delete directory ID')           */
/*********************************************************************/
/*                                                                   */
/*       Midas  SECURITY PROFILE FACILITY                            */
/*                                                                   */
/*       SFC0030- INSERT/AMEND/DELETE DIRECTORY ENTRY                */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*       Prev Amend No. 153286             Date 24Nov99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      102343             Date 06Aug96              */
/*                      086669             DATE 23MAY95              */
/*                      067541             DATE 15MAR94              */
/*                      E30717             DATE 29OCT91              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       153286 - Split-up of &SPCAUT (Special Authority) and check  */
/*                each 10-byte part separately when checking User Id */
/*                for *SECADM authority, to avoid error message 124. */
/*       102343 - Replacement of DSPDIR command with DSPDIRE as      */
/*                DSPDIR has been removed at V3R6 os OS/400          */
/*       086669 - Remove display of information error if user is     */
/*                not enrolled in the system distribution directory. */
/*              - Unable to delete a user in SPF. If action code =   */
/*                'D', issue the command RMVDIRE. Currently action   */
/*                code 'D' causes the program to go into error       */
/*                handling.                                          */
/*              - RMVDIR should only be done if there is entry.      */
/*       067541 - This function is not available if user is not      */
/*                authorised to System Distribution Directory.       */
/*       E30717 - Program declares a file in QTEMP; this prevents    */
/*                compilation if the file does not exist.  Instead,  */
/*                it should declare the IBM-supplied outfile for the */
/*                relevant command (in this case, DSPDIR).           */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&ACTN &RTN &USER &USERD &DIRID &DIRADR)
/*                                                                   */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&ACTN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DIRID) TYPE(*CHAR) LEN(8)
             DCL        VAR(&DIRADR) TYPE(*CHAR) LEN(8)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USERD) TYPE(*CHAR) LEN(50)
             DCL        VAR(&USRPRF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SPCAUT) TYPE(*CHAR) LEN(100)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)            /*067541*/
             DCL        VAR(&SPCAU1) TYPE(*CHAR) LEN(10)             /*153286*/
             DCL        VAR(&SPCAU2) TYPE(*CHAR) LEN(10)             /*153286*/
             DCL        VAR(&SPCAU3) TYPE(*CHAR) LEN(10)             /*153286*/
             DCL        VAR(&SPCAU4) TYPE(*CHAR) LEN(10)             /*153286*/
             DCL        VAR(&SPCAU5) TYPE(*CHAR) LEN(10)             /*153286*/
             DCL        VAR(&SPCAU6) TYPE(*CHAR) LEN(10)             /*153286*/
             DCL        VAR(&SPCAU7) TYPE(*CHAR) LEN(10)             /*153286*/
             DCL        VAR(&SPCAU8) TYPE(*CHAR) LEN(10)             /*153286*/
             DCL        VAR(&SPCAU9) TYPE(*CHAR) LEN(10)             /*153286*/
             DCL        VAR(&SPCAU10) TYPE(*CHAR) LEN(10)            /*153286*/
/*                                                                   */
/*********** DCLF       FILE(QTEMP/TEMP)                               E30717*/
             DCLF       FILE(QSYS/QAOSDIRO)                          /*E30717*/
/*                                                                   */
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) +
                             EXEC(GOTO CMDLBL(ABNOR))                /*067541*/
/* */                                                                /*067541*/
/** Monitor for user not enrolled.                                */ /*067541*/
/** File TEMP is the outfile from the display directory command.  */ /*067541*/
/** This will not have been created if the user is not enrolled   */ /*067541*/
/** in the System Distribution Directory.                         */ /*067541*/
/* */                                                                /*067541*/
             CHKOBJ     OBJ(QTEMP/TEMP) OBJTYPE(*FILE)               /*067541*/
             MONMSG     MSGID(CPF9801) EXEC(DO)                      /*067541*/
/***********      RTVMSG     MSGID(SFM0023) MSGF(MIDASMSG) +
/***********                      MSG(&MESSAGE)       */       /*067541086669*/
/***********      CHGDTAARA  DTAARA(MIDASMSG (251 50)) +
/***********                      VALUE(&MESSAGE)     */       /*067541086669*/
/***********      RTVMSG     MSGID(SFM0024) MSGF(MIDASMSG) +
/***********                      MSG(&MESSAGE)       */       /*067541086669*/
/***********      CHGDTAARA  DTAARA(MIDASMSG (301 50)) +
/***********                      VALUE(&MESSAGE)     */       /*067541086669*/
/***********      CALL       PGM(SFC0700) PARM('SFC0030' 'ENTER' +
/***********                      ' ')                */       /*067541086669*/
                  CHGVAR     VAR(&RTN) VALUE('1')                    /*067541*/
                  GOTO       CMDLBL(EXIT)                            /*067541*/
             ENDDO                                                   /*067541*/
/* */                                                                /*067541*/
/* Override the QSYS file to the one that is actually being used:      E30717*/
             OVRDBF     FILE(QAOSDIRO) TOFILE(QTEMP/TEMP)
                                                                     /*E30717*/
             CHGVAR     VAR(&RTN) VALUE('0')
             RTVUSRPRF  RTNUSRPRF(&USRPRF) SPCAUT(&SPCAUT)
/*                                                                   */
/*  CHECK THE LEVEL OF AUTHORITY FORM THE USER PROFILE WHEN ACTION   */
/*  IS INSERT                                                        */
/*                                                                   */
             IF         COND(&ACTN *EQ 'I') THEN(DO)
             IF         COND(&SPCAUT *NE '*SECADM') THEN(DO)
             CHGVAR     VAR(&RTN) VALUE('1')
             GOTO CMDLBL(EXIT)
             ENDDO
             ENDDO
/*                                                                   */
/*  IF AMEND, CHECK IF THE USER IS CHANGING HIS OWN DIRECTORY ENTRY  */
/*                                                                   */
/**********  IF        COND(&ACTN *EQ 'A' *AND &SPCAUT *NE '*SECADM') +
/**********               THEN(DO)                                    /*153286*/
             CHGVAR     VAR(&SPCAU1) VALUE(%SST(&SPCAUT 1 10))        /*153286*/
             CHGVAR     VAR(&SPCAU2) VALUE(%SST(&SPCAUT 11 10))       /*153286*/
             CHGVAR     VAR(&SPCAU3) VALUE(%SST(&SPCAUT 21 10))       /*153286*/
             CHGVAR     VAR(&SPCAU4) VALUE(%SST(&SPCAUT 31 10))       /*153286*/
             CHGVAR     VAR(&SPCAU5) VALUE(%SST(&SPCAUT 41 10))       /*153286*/
             CHGVAR     VAR(&SPCAU6) VALUE(%SST(&SPCAUT 51 10))       /*153286*/
             CHGVAR     VAR(&SPCAU7) VALUE(%SST(&SPCAUT 61 10))       /*153286*/
             CHGVAR     VAR(&SPCAU8) VALUE(%SST(&SPCAUT 71 10))       /*153286*/
             CHGVAR     VAR(&SPCAU9) VALUE(%SST(&SPCAUT 81 10))       /*153286*/
             CHGVAR     VAR(&SPCAU10) VALUE(%SST(&SPCAUT 91 10))      /*153286*/
             IF         COND(&ACTN *EQ 'A') THEN(DO)                  /*153286*/
/*                                                                      153286*/
             IF         COND(&SPCAU1 *NE '*SECADM' *AND &SPCAU2 +
                         *NE '*SECADM' *AND &SPCAU3 *NE '*SECADM' +
                          *AND &SPCAU4 *NE '*SECADM' +
                          *AND &SPCAU5 *NE '*SECADM' +
                          *AND &SPCAU6 *NE '*SECADM' +
                          *AND &SPCAU7 *NE '*SECADM' +
                          *AND &SPCAU8 *NE '*SECADM' +
                          *AND &SPCAU9 *NE '*SECADM' +
                          *AND &SPCAU10 *NE '*SECADM') THEN(DO)
/*                                                                      153286*/
             IF         COND(&USRPRF *NE &USER) THEN(DO)
             CHGVAR     VAR(&RTN) VALUE('2')
             GOTO CMDLBL(EXIT)
             ENDDO
             ENDDO
             ENDDO                                                    /*153286*/
/*                                                                   */
/*  IF AMEND AND DIRECTORY ENTRY CHANGED, REMOVE AND ENTER A NEW ITEM*/
/*                                                                   */
             IF         COND(&ACTN *EQ 'A') THEN(DO)
             CLRPFM     FILE(QTEMP/TEMP)
                                                                      /*102343*/
/*********** DSPDIR     USER(&USER) OUTPUT(*OUTFILE) +             */ /*102343*/
/***********              OUTFILE(QTEMP/TEMP)                      */ /*102343*/
             DSPDIRE    USER(&USER) OUTPUT(*OUTFILE) +
                          OUTFILE(QTEMP/TEMP)                         /*102343*/
             MONMSG     MSGID(CPF9006)
             RCVF
             MONMSG     MSGID(CPF0864)
             IF         COND(&WOSDDEN *NE &DIRID *OR &WOSDDGN *NE +
                          &DIRADR)  THEN(DO)
             RMVDIRE    USRID(&WOSDDEN &WOSDDGN)
             MONMSG     MSGID(CPF9006 CPF9087)
             ADDDIRE    USRID(&DIRID &DIRADR) USRD(&USERD) +
                          USER(&USER)
             MONMSG     MSGID(CPF9082) EXEC(CHGVAR VAR(&RTN) +
                          VALUE('3'))
             ENDDO
             GOTO CMDLBL(EXIT)
             ENDDO
/*                                                                   */
/*  IF INSERT ADD TO DIRECTORY AND MONITOR FOR MESSAGE               */
/*                                                                   */
             IF         COND(&ACTN *EQ 'I')  THEN(DO)
             CHKOBJ     OBJ(*LIBL/&USER) OBJTYPE(*USRPRF)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CHGVAR     VAR(&RTN) VALUE('4')
             GOTO CMDLBL(EXIT)
             ENDDO
             ADDDIRE    USRID(&DIRID &DIRADR) USRD(&USERD) +
                          USER(&USER)
             MONMSG     MSGID(CPF9082) EXEC(CHGVAR VAR(&RTN) +
                          VALUE('3'))
             GOTO CMDLBL(EXIT)
             ENDDO
/*                                                                */ /*086669*/
/*  IF DELETE, ISSUE THE RMVDIRE COMMAND.                         */ /*086669*/
/*                                                                */ /*086669*/
             IF         COND(&ACTN *EQ 'D')  THEN(DO)                /*086669*/
             IF         COND(&DIRID *NE '        ') THEN(DO)         /*086669*/
             RMVDIRE    USRID(&DIRID &DIRADR) USRD(&USERD)           /*086669*/
             MONMSG     MSGID(CPF9087) EXEC(CHGVAR VAR(&RTN) +
                          VALUE('1'))                                /*086669*/
             ENDDO                                                   /*086669*/
             GOTO CMDLBL(EXIT)                                       /*086669*/
             ENDDO                                                   /*086669*/
/*                                                                   */
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
ABNOR:                                                               /*067541*/
             SNDPGMMSG  MSG('Insert/Amend/Delete Directory ID ended +
                             abnormally') TOMSGQ(MOPERQ MRUNQ)       /*067541*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)               /*067541*/
             RTVMSG     MSGID(SFM0009) MSGF(MIDASMSG) MSG(&MESSAGE)  /*067541*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)               /*067541*/
             CHGDTAARA  DTAARA(MIDASMSG (251 50)) VALUE(&MESSAGE)    /*067541*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)               /*067541*/
             RTVMSG     MSGID(SFM0010) MSGF(MIDASMSG) MSG(&MESSAGE)  /*067541*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)               /*067541*/
             CHGDTAARA  DTAARA(MIDASMSG (301 50)) VALUE(&MESSAGE)    /*067541*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)               /*067541*/
             CHGDTAARA  DTAARA(MIDASMSG (3 1)) VALUE('1')            /*067541*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)               /*067541*/
             CALL       PGM(SFC0700) PARM('SFC0030' 'ENTER' ' ')     /*067541*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)               /*067541*/
EXIT:        ENDPGM
