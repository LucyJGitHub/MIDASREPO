/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UP Prepare compares for screen')                */
/*********************************************************************/
/*                                                                   */
/*       Midas - Upgrade Module                                      */
/*                                                                   */
/*       UPC0501  - Prepare compares for screen                      */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CSM005  *MOVED     Date 17Aug05              */
/*       Prev Amend No. CPK018             Date 23Feb04              */
/*                      CUP024             Date 13Jun03              */
/*                      CSC017             Date 14Feb03              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CPK015             Date 04Apr02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CUP001 *CREATE     DATE 15Feb99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CSM005 - Changes for the Bridge compare for MidasPlus.      */
/*       CPK018 - MidasPlus packaging.  Remove CHKLIBLE processing.  */
/*       CUP024 - Migration of Bridge ICD to the System Values file. */
/*       CSC017 - Change to 250 library list.                        */
/*       CPK015 - 4.01 packaging.  Handling DZLIB.  Recompile.       */
/*       CUP001 - Introduction of BRIDGE                             */
/*                                                                   */
/*********************************************************************/
/**********  PGM        PARM(&QUALNEW &NEWM &QUALOLD &OLDM &NBR &S +                   */ /*CSM005*/
/**********               &RTCMD)                                                      */ /*CSM005*/
             PGM        PARM(&QUALNEW &NEWM &QUALOLD &OLDM &NBR &S +
                          &RTCMD &MRGLIB &PTFUPG)                                         /*CSM005*/
/**COPY*UPCPYSRC,UPSVALDCL*                                          */ /*  */ /*CUP024*/ /*CSM005*/
             DCL        VAR(&QUALNEW) TYPE(*CHAR) LEN(20)
             DCL        VAR(&QUALOLD) TYPE(*CHAR) LEN(20)
             DCL        VAR(&NEWM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OLDM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NEWF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OLDF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NEWL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OLDL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NUM) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&MRGLIB) TYPE(*CHAR) LEN(10)                                  /*CSM005*/
             DCL        VAR(&PTFUPG) TYPE(*CHAR) LEN(10)                                  /*CSM005*/
             DCL        VAR(&TYP) TYPE(*CHAR) LEN(10)
/************DCL        VAR(&LIBL) TYPE(*CHAR) LEN(275)                                */ /*CSC017*/
/************DCL        VAR(&CMD) TYPE(*CHAR) LEN(285)                                 */ /*CSC017*/
             DCL        VAR(&LIBL) TYPE(*CHAR) LEN(2750)                                  /*CSC017*/
             DCL        VAR(&CMD) TYPE(*CHAR) LEN(2764)                                   /*CSC017*/
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)
             DCL        VAR(&NEWME) TYPE(*CHAR) LEN(10)
             DCL        VAR(&S) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTCMD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RETURN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&LENY) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&UPP02X) TYPE(*CHAR) LEN(10)
             DCL        VAR(&UPP02Y) TYPE(*CHAR) LEN(10)
             DCL        VAR(&UPP02) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/************DCLF       FILE(UPUICDPD)                                                 */ /*CUP024*/
 
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO CMDLBL(ABNOR))
 
             CHGJOB     LOG(4 0 *SECLVL) LOGCLPGM(*YES)
             RTVJOBA    USRLIBL(&LIBL)
 
/************RCVF                                                                      */ /*CUP024*/
/************MONMSG     MSGID(CPF0864)                                                 */ /*CUP024*/
/**COPY*UPCPYSRC,UPSVALCAL1*                                         */ /*  */ /*CUP024*/ /*CSM005*/
 
             CHGVAR     VAR(&NEWF) VALUE(%SST(&QUALNEW 1 10))
             CHGVAR     VAR(&OLDF) VALUE(%SST(&QUALOLD 1 10))
             CHGVAR     VAR(&NEWL) VALUE(%SST(&QUALNEW 11 10))
             CHGVAR     VAR(&OLDL) VALUE(%SST(&QUALOLD 11 10))
 
/**CHKLIBLE:                                                                           */ /*CPK018*/
/**********  CHGVAR     VAR(&RETURN) VALUE(' ')                                        */ /*CPK018*/
/**********  CHKLIBLE   LIBS(QTEMP) RETURN(&RETURN)                                    */ /*CPK018*/
/**********  IF         COND(&RETURN *EQ 'F') THEN(DO)                                 */ /*CPK018*/
/**********     EDTLIBL                                                                */ /*CPK018*/
/**********     GOTO CHKLIBLE                                                          */ /*CPK018*/
/**********  ENDDO                                                                     */ /*CPK018*/
 
             RMVLIBLE   LIB(QTEMP)
             MONMSG     MSGID(CPF2104 CPF2110)
             ADDLIBLE   LIB(QTEMP) POSITION(*FIRST)
             MONMSG     MSGID(CPF2103 CPF2110)
 
             RTVMBRD    FILE(&NEWL/&NEWF) MBR(&NEWM) SRCTYPE(&TYP)
             CHGVAR     VAR(%SST(&NEWME 1 4)) VALUE(%SST(&NEWM 1 4))
             CHGVAR     VAR(%SST(&NEWME 5 6)) VALUE(&NBR)
 
             CHGVAR     VAR(&UPP02X) VALUE(UPP02P)
             CHKOBJ     OBJ(&PTFUPG/UPP02P) OBJTYPE(*FILE) MBR(&NEWME)
             MONMSG     MSGID(CPF9815 CPF9801) EXEC(DO)
                CHGVAR     VAR(&UPP02X) VALUE('           ')
             ENDDO
             CHGVAR     VAR(&UPP02Y) VALUE(UPP02PB)
             CHKOBJ     OBJ(&PTFUPG/UPP02PB) OBJTYPE(*FILE) +
                          MBR(&NEWME)
             MONMSG     MSGID(CPF9815 CPF9801) EXEC(DO)
                CHGVAR     VAR(&UPP02Y) VALUE('           ')
             ENDDO
             IF         COND((&UPP02X *EQ '          ') *AND +
                          (&UPP02Y *EQ '          ')) THEN(GOTO +
                          CMDLBL(ABNOR))
             IF         COND(&UPP02X *NE '          ') THEN(DO)
                CHGVAR     VAR(&UPP02) VALUE(UPP02P)
             ENDDO
             IF         COND(&UPP02Y *NE '          ') THEN(DO)
                CHGVAR     VAR(&UPP02) VALUE(UPP02PB)
             ENDDO
             CALL       PGM(UPC0580) PARM(&UPP02 &PTFUPG &LENY)
             IF         COND(&LENY *EQ 112) THEN(DO)
                OVRDBF     FILE(UPP02P) TOFILE(&PTFUPG/UPP02P) +
                          MBR(&NEWME)
             ENDDO
             IF         COND(&LENY *EQ 092) THEN(DO)
                OVRDBF     FILE(UPP02P) TOFILE(&PTFUPG/UPP02PB) +
                          MBR(&NEWME)
             ENDDO
             OVRDBF     FILE(UPP03P) TOFILE(&PTFUPG/UPP03P) +
                          MBR(&NEWME)
             IF         COND(&LENY *EQ 112) THEN(DO)
/**********     CALL      PGM(UP0530) PARM(&NEWL &NEWF &NEWM ' ' &TYP +                */ /*CSM005*/
/**********               &NEWME &OLDL &OLDF &OLDM &S &RTCMD)                          */ /*CSM005*/
                CALL       PGM(UP0530) PARM(&NEWL &NEWF &NEWM ' ' &TYP +
                             &NEWME &OLDL &OLDF &OLDM &S &RTCMD +
                             &MRGLIB &PTFUPG)                                             /*CSM005*/
             ENDDO
             IF         COND(&LENY *EQ 092) THEN(DO)
/**********     CALL     PGM(UP0530B) PARM(&NEWL &NEWF &NEWM ' ' &TYP +                */ /*CSM005*/
/**********               &NEWME &OLDL &OLDF &OLDM &S &RTCMD)                          */ /*CSM005*/
                CALL       PGM(UP0530B) PARM(&NEWL &NEWF &NEWM ' ' &TYP +
                             &NEWME &OLDL &OLDF &OLDM &S &RTCMD +
                             &MRGLIB &PTFUPG)                                             /*CSM005*/
             ENDDO
             IF         COND(&LENY *EQ 112) THEN(DO)
                DLTOVR     FILE(UPP02P)
             ENDDO
             IF         COND(&LENY *EQ 092) THEN(DO)
                DLTOVR     FILE(UPP02PB)
             ENDDO
             DLTOVR     FILE(UPP03P)
 
             RETURN
 
ABNOR:
             IF         COND(&CMD *NE '       ') THEN(DO)
                CHGVAR   VAR(&CMD) VALUE('CHGLIBL (' *CAT &LIBL *TCAT +
                          ')')
/************   CALL       PGM(QCMDEXC) PARM(&CMD 285)                                 */ /*CSC017*/
                CALL       PGM(QCMDEXC) PARM(&CMD 2764)                                   /*CSC017*/
                MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
