/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Component for enqy program RE3363')          */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                                       */
/*                                                                   */
/*       REC3363 - CONTROLLING CL COMPONENT FOR INTEREST DETAILS     */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CAP084             Date 08Jul03              */
/*       Prev Amend No. CSF002             Date 11Aug03              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CSC014             Date 11Apr02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      179663             DATE 12Jun00              */
/* Midas DBA 3.02 ---------------------------------------------------*/
/*                      149175             DATE 21Oct99              */
/*                      153379             DATE 15Oct99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01408             DATE 09MAY95              */
/*                      069698             DATE 19APR94              */
/*                      S01413 *CREATE     DATE 13APR93              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CAP084 - Parameter added to ZMUSER for Java wrappers        */
/*       CSF002 - Global layer.                                      */
/*                Remove the command which sets up SFC0600 as the    */
/*                program to be called when Attention Key is pressed */
/*                since SFC0600 is made redundant already.           */
/*       CSC014 - Allow support for DBCS (Recompiled)                */
/*       179663 - Change override of REUSRMSG to be correct. Now     */
/*                done by MLCOVR /COPYs.                             */
/*       149175 - Include /COPY member MLCOVROVR, as per GLC441.     */
/*       153379 - The RECJOB group session SETANTPGM is SFC0600      */
/*                (the manual instruction) rather than the session   */
/*                manager SETATNPGM SFC4460, so RECJOB group jobs    */
/*                are not open to session manager due to limitation  */
/*                problems. (Fix 122745.)                            */
/*       S01408 - Addition of core hook REC3363MP1                   */
/*       069698 - Applied as preventative maintenance. QTEMP is      */
/*                not top of the library list at R10.5.              */
/*       S01413 - Retail 3 Incorporation                             */
/*                                                                   */
/*********************************************************************/
/* */
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(1)   VALUE('0')
             DCL        VAR(&MBIN) TYPE(*CHAR) LEN(1)
/* */
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)
/* */
             DCL        VAR(&MULT) TYPE(*CHAR) LEN(2)
/************DCL        VAR(&ZZMSGF) TYPE(*CHAR) LEN(10) ***/         /*149175*/
             DCL        VAR(&GROUP) TYPE(*CHAR) LEN(50)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(25)
             DCL        VAR(&SLEVEL) TYPE(*DEC) LEN(4)
             DCL        VAR(&TIMEO) TYPE(*DEC) LEN(5)
             DCL        VAR(&ERRORC) TYPE(*DEC) LEN(1) VALUE(0)
             DCL        VAR(&GRPJOBNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ZMUSER) TYPE(*CHAR) LEN(10)                                  /*CAP084*/
/*/COPY MLCPYSRC,MLCOVRDCL                                         */ /*149175*/
/* */
             RTVDTAARA  DTAARA(SDSTAT *ALL) RTNVAR(&SDSTAT)
             CHGVAR     VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))
             CHGVAR     VAR(&DMLIB) VALUE(&PRE *TCAT 'DMLIB')
                                                                      /*S01408*/
/*/COPY WNCPYSRC,REC3363MP1                                          */
                                                                      /*S01408*/
/* */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
/*/COPY MLCPYSRC,MLCOVROVR                                         */ /*149175*/
/* */
             RTVDTAARA  DTAARA(*GDA (450 10)) RTNVAR(&GRPJOBNAM)
/************IF         COND(%SST(&GRPJOBNAM 1 5) *EQ 'S1405') +       153379*/
/************             THEN(SETATNPGM PGM(SFC4460))                 153379*/
/************ELSE       CMD(SETATNPGM PGM(SFC0600))                    153379*/
/**********  SETATNPGM  PGM(SFC0600)                                           /*153379*/ /*CSF002*/
/* */
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9815 CPF9801) EXEC(DO)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             ENDDO
/* */
             RTVDTAARA  DTAARA(RUNDAT (13 1)) RTNVAR(&MBIN)
/* */
/*   Create and set up user data area            */
/* */
             IF         COND(&MBIN *EQ 'Y') THEN(CALL PGM(SFC0400))
/* */
             CHKOBJ     OBJ(QTEMP/ZMUSER) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9815 CPF9801) EXEC(DO)
/************CALL       PGM(ZMUSER) PARM(&ERRORC)                                         /*CAP084*/
             CALL       PGM(ZMUSER) PARM(&ERRORC &ZMUSER)                                 /*CAP084*/
             IF         COND(&ERRORC *NE 0) THEN(DO)
             SNDPGMMSG  MSG('Default Branch or Department not valid') +
                        TOPGMQ(*EXT) MSGTYPE(*INFO)
             SIGNOFF    LOG(*LIST)
             MONMSG     MSGID(CPF0000) /* Monitor here to prevent +
                          error during re-routing of job */
             ENDDO
             ENDDO
/* */
             CALL       PGM(SF0410) PARM(&GROUP &USER &SLEVEL &TIMEO +
                          &ERRORC &MULT)
/* */
             IF         COND(&MULT *EQ '  ') THEN(DO)
             CHGVAR     VAR(&MULT) VALUE('GB')
             ENDDO
/* */
/*********** CHGVAR   VAR(&ZZMSGF) VALUE(&MULT *CAT 'REUSRMSG') */   /*179663*/
/* */
/*********** OVRMSGF    MSGF(REUSRMSG) TOMSGF(&ZZMSGF)          */   /*179663*/
 
/**/
/**  At this point control is transferred to the enquiry       */
/**  program and will not return to this CL program unless     */
/**                                                            */
/**   (i)    A user presses CMD 1 during this enquiry program  */
/**   (ii)   A database error occurs  within the enquiry       */
/**   (iii)  A program crash occurs  within the enquiry        */
/**/
             CHKOBJ     OBJ(QTEMP/RECAPM) OBJTYPE(*FILE)
/* */
             MONMSG     MSGID(CPF9801) EXEC(CRTDUPOBJ OBJ(RECAPM) +
                          FROMLIB(&DMLIB) OBJTYPE(*FILE) TOLIB(QTEMP))
/* */
             CLRPFM QTEMP/RECAPM
/* */
             OVRDBF     FILE(REHISL) TOFILE(REHISL) SHARE(*NO)
             OVRDBF     FILE(RECAPM) TOFILE(QTEMP/RECAPM) +
                          SHARE(*YES)                                 /*069698*/
/* */
             CALL       PGM(RE3363)
/* */
             DLTOVR     FILE(REHISL)
             DLTOVR     FILE(RECAPM)                                  /*069698*/
 
/**/
/**  If a data base error occurred within the enquiry program  */
/**  then the error will be handled by the group job program   */
/**  REC360.  An error may also occur in a program called     */
/**  from within the enquiry, if so switch '1' will be set ON. */
/**/
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(CHGVAR +
                          VAR(&RTNCDE) VALUE('1'))
             ELSE
               IF         COND(%SWITCH(1XXXXXXX)) THEN(CHGVAR +
                            VAR(&RTNCDE) VALUE('3'))
/* */
             GOTO       CMDLBL(RETRN)
 
/**/
/**  If an error other than a data base error occurs then      */
/**  again REC360 will handle it by producing a job log        */
/**/
 
 ABNOR:      CHGVAR     VAR(&RTNCDE) VALUE('2')
 
/**/
/**  Before returning to the controlling program ensure that   */
/**  *GDA contains the contents of *LDA and the end status     */
/**  of this program.                                          */
/**/
 
 RETRN:      CALL       PGM(REC360A) PARM('O')
             CHGDTAARA  DTAARA(*GDA (460 1)) VALUE(&RTNCDE)
             TFRGRPJOB  GRPJOB(&GRPJOBNAM)
/* */
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
