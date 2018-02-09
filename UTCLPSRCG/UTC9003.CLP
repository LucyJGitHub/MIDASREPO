/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UT Rebuild binding directory - valdty chckr')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities Module                                    */
/*                                                                   */
/*       UTC9003 - Validity Checker for RBDBNDDIR (Rebuild           */
/*                 binding directory) command.                       */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CPK018             Date 26Apr04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      137831             Date 26Jun98              */
/*                      CAP002  *CREATE    Date 04NOV97              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPK018 - MidasPlus packaging.  Moved to global layer.       */
/*       137831 - Fix for full library list problem in UTC9002.      */
/*                No change to this program for this fix, but took   */
/*                the opportunity to fix a checking and monitoring   */
/*                problem in this program (it was trying to check    */
/*                for a library name of '*USRLIBL').                 */
/*       CAP002 - Conversion of Midas inputs to modular API structure*/
/*                                                                   */
/*********************************************************************/
          PGM        PARM(&DIRANDLIB &OBJLIB &OBJTYP)
 
          DCL        VAR(&DIRANDLIB) TYPE(*CHAR) LEN(20) /* +
                       Binding directory and library */
          DCL        VAR(&OBJLIB) TYPE(*CHAR) LEN(10) /* Library +
                       containing modules and sevice programs */
          DCL        VAR(&OBJTYP) TYPE(*CHAR) LEN(7) /* Which +
                       object type(s) to include */
 
          DCL        VAR(&BNDDIR) TYPE(*CHAR) LEN(10) /* Binding +
                       directory name */
          DCL        VAR(&BNDDIRLIB) TYPE(*CHAR) LEN(10) /* +
                       Binding directory library */
 
          DCL        VAR(&ERROR) TYPE(*CHAR) LEN(1) VALUE('N')
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/*/COPY WNCPYSRC,UTC9003INT                                          */
 
/* Global monitor message */
 
          MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                       CMDLBL(ABNOR))
 
/*/COPY WNCPYSRC,UTC9003MPS                                          */
 
/** Separate binding directory and library **/
          CHGVAR     VAR(&BNDDIR) VALUE(&DIRANDLIB)
          CHGVAR     VAR(&BNDDIRLIB) VALUE(%SST(&DIRANDLIB 11 10))
 
/* Check that the binding directory library exists & the user is    */
/*  authorised to it (if it is not one of the special values)       */
          IF         COND(&BNDDIRLIB *NE '*LIBL'  *AND +
                          &BNDDIRLIB *NE '*USRLIBL') THEN(DO) /*137831*/
             CHKOBJ     OBJ(QSYS/&BNDDIRLIB) OBJTYPE(*LIB) +
                          AUT(*CHANGE)
             MONMSG     MSGID(CPF9800) EXEC(DO)
                SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) MSGDTA('0000 +
                             Binding directory library does not exist +
                             or you lack sufficient authority') +
                             MSGTYPE(*DIAG)
                CHGVAR     VAR(&ERROR)  VALUE('Y')
             ENDDO
          ENDDO                                              /*137831*/
 
/* Check that the binding directory exist & the user is             */
/*  authorised to it                                                */
/** +
    If binding directory library is '*USRLIBL', replace it with +
    '*LIBL', as CHKOBJ can't handle the former +
**/                                                          /*137831*/
          IF         COND(&BNDDIRLIB = '*USRLIBL') THEN(CHGVAR +
                       VAR(&BNDDIRLIB) VALUE('*LIBL'))       /*137831*/
          IF         COND(&ERROR *NE 'Y') THEN(DO)
             CHKOBJ     OBJ(&BNDDIRLIB/&BNDDIR) OBJTYPE(*BNDDIR) +
                          AUT(*CHANGE)
             MONMSG     MSGID(CPF9800) EXEC(DO)
                SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) MSGDTA('0000 +
                             Binding directory does not exist or you +
                             lack sufficient authority') MSGTYPE(*DIAG)
                CHGVAR     VAR(&ERROR)  VALUE('Y')
             ENDDO
          ENDDO
 
 
/* Check that the objects library exists & the user is authorised   */
/*  to it (if it is not one of the special values)                  */
          IF         COND(&OBJLIB *NE '*LIBL'  *AND +
                          &OBJLIB *NE '*USRLIBL') THEN(DO)
             CHKOBJ     OBJ(QSYS/&OBJLIB) OBJTYPE(*LIB) AUT(*USE)
             MONMSG     MSGID(CPF9800) EXEC(DO)
             SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) MSGDTA('0000 +
                          Objects library does not exist or you +
                          lack sufficient authority') MSGTYPE(*DIAG)
             CHGVAR     VAR(&ERROR) VALUE('Y')
             ENDDO
          ENDDO
 
/*  SEND MESSAGE TO CAUSE CPF TO PASS EARLIER MESSAGES BACK         */
 
             IF         COND(&ERROR *EQ 'Y') THEN(DO)
                SNDPGMMSG  MSGID(CPF0002) MSGF(QCPFMSG) MSGTYPE(*ESCAPE)
             ENDDO
 
/*/COPY WNCPYSRC,UTC9003MPE                                          */
 
          GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,UTC9003ERR                                          */
 
          SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) MSGDTA('0000 +
                       Error detected during RBDBNDDIR command') +
                       MSGTYPE(*DIAG)
             MONMSG     MSGID(CPF0000)                       /*137831*/
 
/*  SEND MESSAGE TO CAUSE CPF TO PASS EARLIER MESSAGES BACK */ /*137831*/
 
             IF         COND(&ERROR *EQ 'Y') THEN(DO)        /*137831*/
                SNDPGMMSG  MSGID(CPF0002) MSGF(QCPFMSG) +
                             MSGTYPE(*ESCAPE)                /*137831*/
                MONMSG     MSGID(CPF0000)                    /*137831*/
             ENDDO                                           /*137831*/
 
/** STANDARD CPP ERROR HANDLING HERE **/
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/*/COPY WNCPYSRC,UTC9003END                                          */
 
/* (Add any specific end processing here) */
 
          ENDPGM
