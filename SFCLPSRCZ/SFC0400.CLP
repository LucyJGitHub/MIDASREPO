/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SF Set-up multibranching DTAARAs')              */
/*********************************************************************/
/*                                                                   */
/*  Midas Security Profile Facility                                  */
/*                                                                   */
/*  SFC0400 - SET UP MULTIBRANCHING DATA AREAS                       */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. AR1072179          Date 13Feb13              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Prev Amend No. 247277             Date 24May07              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      BUG1699            Date 31Mar04              */
/*                      226108   BUG483    Date 29Mar04              */
/*                      CAP084             Date 08Jul03              */
/* Midas Release 4.01.02 --------------------------------------------*/
/*                      197434             Date 09Oct01              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      E28090             Date 06Sep91              */
/*                      RT0157             Date 24Jun91              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       AR1072179 - APISERVFL and APISERVMQ jobs on MSGW            */
/*       247277 - Need to cater for native JDBC driver.              */
/*       BUG1699 - Unable to recreate ZMUSER                         */
/*       226108 - Need to re-create ZMUSER when switching zone       */
/*       CAP084 - Parameter added to ZMUSER for Java wrappers        */
/*       197434 - Array index error on SF0021. Increase maximum      */
/*                number of branches from 100 to 900.                */
/*  E28090 - Amend calls to SFC0700 to reflect the rewrite           */
/*           of that program.                                        */
/*  RT0157 - Messages should be sent via new Midas Info Screen.      */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&ERRCOD) TYPE(*DEC) LEN(1)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)             /*E28090*/
             DCL        VAR(&ZMUSER) TYPE(*CHAR) LEN(10)                                  /*CAP084*/
             DCL        VAR(&JOBNAME) TYPE(*CHAR) LEN(10)                                /*BUG1699*/
                                                                                       /*AR1072179*/
/* Create the Midas Information Screen data area */                                    /*AR1072179*/
                                                                                       /*AR1072179*/
             CRTDTAARA  DTAARA(QTEMP/MIDASMSG) TYPE(*CHAR) LEN(800) +
                          VALUE(' ') TEXT('Midas SC Midas +
                          information screen data')                                    /*AR1072179*/
             MONMSG     MSGID(CPF1023)                                                 /*AR1072179*/
/* */
/*   CREATE AND SET UP USER DATA AREA    */
/* */
             CRTDTAARA  DTAARA(QTEMP/ZBRU) TYPE(*CHAR) LEN(304) +
                          TEXT('User valid Booking Branches')
             MONMSG     MSGID(CPF0000) /* Monitor here to prevent +
                          error during re-routing of job */
                                                                                          /*197434*/
/** Create more data area to contain the valid booking branches */                        /*197434*/
             CRTDTAARA  DTAARA(QTEMP/ZBRU1) TYPE(*CHAR) LEN(1998) +
                          TEXT('User valid Booking Branches 1')                           /*197434*/
             MONMSG     MSGID(CPF0000)                                                    /*197434*/
             CRTDTAARA  DTAARA(QTEMP/ZBRU2) TYPE(*CHAR) LEN(402) +
                          TEXT('User valid Booking Branches 2')                           /*197434*/
             MONMSG     MSGID(CPF0000)                                                    /*197434*/
                                                                                          /*197434*/
             CRTDTAARA  DTAARA(QTEMP/ZOBU) TYPE(*CHAR) LEN(304) +
                          TEXT('User valid Originating Branches')
             MONMSG     MSGID(CPF0000) /* Monitor here to prevent +
                          error during re-routing of job */
                                                                                          /*197434*/
/** Create more data area to contain the valid originating branches*/                     /*197434*/
             CRTDTAARA  DTAARA(QTEMP/ZOBU1) TYPE(*CHAR) LEN(1998) +
                          TEXT('User valid Originating Branches 1')                       /*197434*/
             MONMSG     MSGID(CPF0000)                                                    /*197434*/
             CRTDTAARA  DTAARA(QTEMP/ZOBU2) TYPE(*CHAR) LEN(402) +
                          TEXT('User valid Originating Branches 2')                       /*197434*/
             MONMSG     MSGID(CPF0000)                                                    /*197434*/
                                                                                          /*197434*/
             CRTDTAARA  DTAARA(QTEMP/ZCMP) TYPE(*CHAR) LEN(304) +
                          TEXT('User valid Companies')
             MONMSG     MSGID(CPF0000) /* Monitor here to prevent +
                          error during re-routing of job */
/* */
/*  THE DATA AREA ZMUSER NEED TO BE CREATED IN QTEMP */
/* */
             RTVJOBA    JOB(&JOBNAME)                                                    /*BUG1699*/
/********    IF COND(&JOBNAME *NE 'QZDASOINIT') THEN(DO)                          /*BUG1699 247277*/
             IF         COND((&JOBNAME *NE 'QZDASOINIT') *AND +
                          (&JOBNAME *NE 'QSQSRVR')) THEN(DO)                              /*247277*/
             DLTDTAARA  DTAARA(QTEMP/ZMUSER)                                              /*226108*/
             MONMSG     MSGID(CPF2105)                                                    /*226108*/
             CHKOBJ     OBJ(QTEMP/ZMUSER) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9815 CPF9801) EXEC(DO)
/************   CALL       PGM(ZMUSER) PARM(&ERRCOD)                                      /*CAP084*/
                CALL       PGM(ZMUSER) PARM(&ERRCOD &ZMUSER)                              /*CAP084*/
                IF         COND(&ERRCOD *NE 0) THEN(DO)
/************SNDPGMMSG  MSG('Default Branch or Department not +       /*RT0157*/
/************             valid') TOPGMQ(*EXT) MSGTYPE(*INFO)         /*RT0157*/
/************      CALL       PGM(SFC0700) PARM('SFC0400' +
/************                   'DFTBRCNOGO' ' ')          /*RT0157*/ /*E28090*/
                   RTVMSG     MSGID(SFM0007) MSGF(MIDASMSG) +
                                MSG(&MESSAGE)                         /*E28090*/
                   MONMSG     MSGID(CPF0000 RPG0000 MCH0000)          /*E28090*/
                   CHGDTAARA  DTAARA(MIDASMSG (251 50)) +
                                VALUE(&MESSAGE)                       /*E28090*/
                   MONMSG     MSGID(CPF0000 RPG0000 MCH0000)          /*E28090*/
                   RTVMSG     MSGID(SFM0008) MSGF(MIDASMSG) +
                                MSG(&MESSAGE)                         /*E28090*/
                   MONMSG     MSGID(CPF0000 RPG0000 MCH0000)          /*E28090*/
                   CHGDTAARA  DTAARA(MIDASMSG (401 50)) +
                                VALUE(&MESSAGE)                       /*E28090*/
                   MONMSG     MSGID(CPF0000 RPG0000 MCH0000)          /*E28090*/
                   CHGDTAARA  DTAARA(MIDASMSG (2 1)) VALUE('1')       /*E28090*/
                   MONMSG     MSGID(CPF0000 RPG0000 MCH0000)          /*E28090*/
                   CALL      PGM(SFC0700) PARM('SFC0400' 'ENTER' ' ') /*E28090*/
                   MONMSG     MSGID(CPF0000 MCH0000 RPG0000)          /*E28090*/
                   SIGNOFF    LOG(*LIST)
                   MONMSG     MSGID(CPF0000) /* Monitor here +
                                to prevent error during re-routing +
                                of job */
                ENDDO
             ENDDO
             ENDDO                                                                       /*BUG1699*/
 
 JUMP:       CALL       PGM(SF0400)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
ENDPGM:      ENDPGM
