/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RP prepare importation of Meridian script.')    */
/*********************************************************************/
/*                                                                   */
/*       Midas - Private Banking Module                              */
/*                                                                   */
/*       RPC1304 - Copies Meridian script data in AS/400 document    */
/*                 to database file in QGPL                          */
/*                                                                   */
/*       Function:    This CLP program allows to copy the data in a  */
/*                 PC document to a database file in library QGPL.   */
/*                    PC Document was created while exporting        */
/*                 filters to AS/400 by using Meridian Repository    */
/*                 Editor.                                           */
/*                     Database file in library QGPL is used to      */
/*                  import filters into Meridian Replication by      */
/*                  using Meridian menu (MMENU).                     */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. 210540             Date 11Oct02              */
/* Midas Release 4.01 -----------------------------------------------*/
/*       Prev Amend No. 193273             Date 24Oct01              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      CPB002  *CREATE    Date 01Jun99              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*       210540 - Due to V5 R1, the library QIWS is removed.         */
/*                Duplicate message to internal message file.        */
/*       193273 - Delete the repository file in QGPL if it exists    */
/*                when the cmd RPIMPORT is used and the option       */
/*                *replace is Yes.                                   */
/*       CPB002 - Meridian DBA Middleware Replication Customization. */
/*                                                                   */
/*********************************************************************/
 
             PGM        PARM(&Folder &Fromdoc &Tofile &Replace)
 
/*-------------------------------------------------------------------*/
/*  Parameters declaration.                                          */
/*-------------------------------------------------------------------*/
 
             DCL        VAR(&Folder)   TYPE(*CHAR) LEN(63)
             DCL        VAR(&Fromdoc)  TYPE(*CHAR) LEN(12)
             DCL        VAR(&Tofile)   TYPE(*CHAR) LEN(20)
             DCL        VAR(&Replace)  TYPE(*CHAR) LEN(4)
 
/*-------------------------------------------------------------------*/
/*  Variables declaration.                                           */
/*-------------------------------------------------------------------*/
 
             DCL        VAR(&Job)      TYPE(*CHAR) LEN(10)
             DCL        VAR(&Msgid)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&Msgf)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&Msgflib)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&Msgdta)   TYPE(*CHAR) LEN(128)
             DCL        VAR(&File)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&Lib)      TYPE(*CHAR) LEN(10)
 
             DCL        VAR(&Group)     TYPE(*CHAR) LEN(50)             /*210540*/
             DCL        VAR(&User)      TYPE(*CHAR) LEN(25)             /*210540*/
             DCL        VAR(&Slevel)    TYPE(*DEC)  LEN(4)              /*210540*/
             DCL        VAR(&Timeo)     TYPE(*DEC)  LEN(5)              /*210540*/
             DCL        VAR(&Mult)      TYPE(*CHAR) LEN(2)              /*210540*/
             DCL        VAR(&Errorc)    TYPE(*DEC)  LEN(1)  VALUE(0)    /*210540*/
                                                                        /*210540*/
             DCL        VAR(&Pbusrmsg)  TYPE(*CHAR) LEN(10)             /*210540*/
                 /* Midas PB User Messages.  */                         /*210540*/
                                                                        /*210540*/
             DCL        VAR(&Cpyfld)   TYPE(*CHAR) LEN(64) VALUE('(C) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/*-------------------------------------------------------------------*/
/*  Global Monitor Message.                                          */
/*-------------------------------------------------------------------*/
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*-------------------------------------------------------------------*/ /*210540*/
/*  Initial processing for user defined language.                    */ /*210540*/
/*-------------------------------------------------------------------*/ /*210540*/
                                                                        /*210540*/
             CALL       PGM(SF0410) PARM(&GROUP &USER &SLEVEL &TIMEO  +
                          &ERRORC &MULT)                                /*210540*/
                                                                        /*210540*/
             IF         COND(&MULT *EQ '  ') THEN(DO)                   /*210540*/
                   CHGVAR     VAR(&MULT) VALUE('GB')                    /*210540*/
             ENDDO                                                      /*210540*/
                                                                        /*210540*/
/*-------------------------------------------------------------------*/ /*210540*/
/*  Override Message Files.                                          */ /*210540*/
/*-------------------------------------------------------------------*/ /*210540*/
                                                                        /*210540*/
             CHGVAR     VAR(&Pbusrmsg) VALUE(&Mult *CAT 'PBUSRMSG  ')   /*210540*/
                                                                        /*210540*/
/*-------------------------------------------------------------------*/
/*  Retrieve job name.                                               */
/*-------------------------------------------------------------------*/
 
             RTVJOBA    JOB(&Job)
 
/*-------------------------------------------------------------------*/
/*  Create "to" file.                                                */
/*-------------------------------------------------------------------*/
 
             CHGVAR     VAR(&File)  VALUE(%SST(&TOFILE 1 10))
             CHGVAR     VAR(&Lib)   VALUE(%SST(&TOFILE 11 10))
 
/**********  CRTPF      FILE(&Lib/&File) RCDLEN(100)                   */ /*193273*/
/**********  MONMSG     MSGID(CPF5813 CPF7302)                         */ /*193273*/
CRTPF:       CRTPF      FILE(&Lib/&File) RCDLEN(100)                      /*193273*/
             MONMSG     MSGID(CPF5813 CPF7302) EXEC(DO)                   /*193273*/
                                                                          /*193273*/
                  If COND(&REPLACE = '*YES') Then(DO)                     /*193273*/
                      DLTF &lib/&file                                     /*193273*/
                      goto CRTPF                                          /*193273*/
                  ENDDO                                                   /*193273*/
                                                                          /*193273*/
             enddo                                                        /*193273*/
/*-------------------------------------------------------------------*/
/*  Copy data in PC document to "to" database file.                  */
/*-------------------------------------------------------------------*/
 
             CPYFRMPCD  FROMFLR(&Folder) TOFILE(&Lib/&File) +
                          FROMDOC(&Fromdoc)
 
             RCVMSG     MSGTYPE(*LAST) MSGDTA(&Msgdta) MSGID(&Msgid) +
                          MSGF(&Msgf) MSGFLIB(&Msgflib)
             IF         COND(&Msgflib = '*LIBL') THEN(DO)
                   CHGVAR  VAR(&Msgflib) VALUE('QIWS')
             ENDDO
/**********  SNDPGMMSG  MSGID(&Msgid) MSGF(&Msgflib/&Msgf) + */           /*210540*/
/**********               MSGDTA(&Msgdta) TOPGMQ(*PRV)       */           /*210540*/
             SNDPGMMSG  MSGID(RP00067) MSGF(&PBUSRMSG) MSGDTA(&Msgdta) +
                          TOPGMQ(*PRV)                                    /*210540*/
             MONMSG     MSGID(CPF0000)                                    /*210540*/
 
             GOTO ENDPGM
 
/*-------------------------------------------------------------------*/
/*  Abnormal Termination.                                            */
/*-------------------------------------------------------------------*/
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             DMPCLPGM
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CHGVAR     VAR(&Msgdta) +
                          VALUE('RPC1304 - Prepare Meridian script +
                                 importation - ended abnormally. See job log')
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(&Msgdta) +
                          TOPGMQ(*PRV)
             MONMSG     MSGID(CPF0000 MCH0000)
 
/*-------------------------------------------------------------------*/
/*  End processing.                                                  */
/*-------------------------------------------------------------------*/
 
 ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
