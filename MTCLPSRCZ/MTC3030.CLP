/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MT Control Incoming Telex processing')          */
/*********************************************************************/
/*                                                                   */
/*     Midas - Midas/TESTKEY INTERFACE                           */
/*                                                                   */
/*     MTC3030 - INCOMING TELEXES PROCESSING                         */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*     Last Amend No  BG18886     DATE   28May08                     */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*     Prev Amend No.  081509     DATE   13OCT94                     */
/*                     067234     DATE   17FEB94                     */
/*                     E29983     DATE   22/10/91                    */
/*                     S01179     DATE   22/10/88                    */
/*                                                                   */
/*********************************************************************/
/*    BG18886 - Amend non-standard codes.                            */
/*     081509 -- Send user a message if they try to start a Testkey  */
/*               session from a non-predinined testkey pc.           */
/*     067234 -- Change all STRPCCMDs to PAUSE(*NO)                  */
/*     E29983 -- CONVERSION TO REL 10 CHANGE DLIB TO DMLIB AS DLIB   */
/*               DOES NOT EXIST AT REL 10                            */
/*     S01179 -- AS/400 CONVERSION                                   */
/*********************************************************************/
             PGM
/*                                                                   */
/*     DECLARE PROGRAM VARIABLES                                     */
/*                                                                   */
/************DCL        VAR(&DISK) TYPE(*CHAR) LEN(6)              */ /*S01179*/
             DCL        VAR(&FLDR) TYPE(*CHAR) LEN(6)                 /*S01179*/
             DCL        VAR(&NAME) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&X) TYPE(*DEC) LEN(2 0) VALUE(1)
             DCL        VAR(&Y) TYPE(*DEC) LEN(1 0) VALUE(0)
             DCL        VAR(&Z) TYPE(*CHAR) LEN(1)
             DCL        &LIB          TYPE(*CHAR)  LEN(10)
/************DCLF       FILE(MTC3000DF)                            */ /*S01179*/
/*           DCLDTAARA  DTAARA(N#ZTK)                               *  *AS400*/
             DCL        VAR(&N#ZTK) TYPE(*CHAR) LEN(100)              /*AS400*/
/*           DCLDTAARA  SDSTAT                                      *  *AS400*/
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)             /*AS400*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/*                                                                   */
/* N.B. The second character of the data area is sometimes printed as*/
/*    a 'pound' sign not a 'hash' sign, depending on which type      */
/*      of keyboard is used                                          */
/*                                                                   */
/* Global monitor message                                            */
/*                                                                   */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/**/
/*                                                                   */
/* Put the library QTEMP at the top of the library list              */
/*                                                                   */
             RMVLIBLE   LIB(QTEMP)
             ADDLIBLE   LIB(QTEMP) POSITION(*FIRST)
/**/
/*                                                                   */
/**Add*QIWS*to*library*list*for*PC*Support*                        */ /*S01179*/
/*                                                                   */
/************ADDLIBLE   LIB(QIWS) POSITION(*LAST)                  */ /*S01179*/
/************MONMSG     MSGID(CPF2103)                             */ /*S01179*/
/*                                                                   */
/* Allocate the data area N#ZTK for 'share read'                     */
/* If the data area is unavailabe, send a msg to the workstation     */
/* and terminate                                                     */
/*                                                                   */
             ALCOBJ     OBJ((N#ZTK *DTAARA *SHRRD))
             MONMSG     MSGID(CPF1002) EXEC(DO)
                SNDPGMMSG  MSG('Unable to allocate data area N#ZTK. +
                          Press Enter.') TOPGMQ(*EXT)
                GOTO END
             ENDDO
/**/
/* Start PC Support Organiser                                      */ /*S01179*/
             STRPCO                                                   /*S01179*/
             MONMSG     MSGID(IWS4032) EXEC(DO)                       /*081509*/
              SNDPGMMSG  MSG('This is not a programmable workstation, +
                           Testkey cannot be operated from it. Try +
                           the option again using an authorised PC +
                           session as defined in the Testkey +
                           Installation Control option from the +
                           Midas menu.') TOPGMQ(*EXT)                 /*081509*/
              GOTO       CMDLBL(END)                                  /*081509*/
             ENDDO                                                    /*081509*/
             MONMSG     MSGID(IWS4010) EXEC(GOTO CMDLBL(SKIP))        /*S01179*/
             DLYJOB 15                                                /*S01179*/
/*                                                                   */
/* Retrieve the job attributes of the current job to obtain the      */
/**job*name*and*also*set*up*the*name*of*the*'DLIB'******************/ /*E29983*/
/* job name and also set up the name of the 'DMLIB'                */ /*E29983*/
/*                                                                   */
 
SKIP:        RTVJOBA    JOB(&NAME)
/*           RCVDTAARA  SDSTAT                                      */ /*AS400*/
             RTVDTAARA  SDSTAT RTNVAR(&SDSTAT)                         /*AS400*/
/************CHGVAR    &LIB  VALUE(%SUBSTRING(&SDSTAT 6 2)  'DLIB')*/ /*E29983*/
/************CHGVAR    &LIB  VALUE(%SUBSTRING(&SDSTAT 6 2)**'DMLIB')*/  /*E29983*/ /*BG18886*/
             CHGVAR    &LIB  VALUE(%SUBSTRING(&SDSTAT 6 2) *CAT 'DMLIB')    /*E29983*/ /*BG18886*/
/*                                                                   */
/* Search the data area N#ZTK and then set up the value of the       */
/**virtual*disk*associated*with*this*PC*                           */ /*S01179*/
/* Folder associated with this PC                              */     /*S01179*/
/*                                                                   */
/*           RCVDTAARA  DTAARA(N#ZTK)                               */ /*AS400*/
             RTVDTAARA  DTAARA(N#ZTK) RTNVAR(&N#ZTK)                   /*AS400*/
 LOOP:       CHGVAR     VAR(&WSID) VALUE(%SUBSTRING(&N#ZTK &X 10))
                IF COND(&NAME *EQ &WSID) THEN(DO)
                   CHGVAR     VAR(&Z) VALUE(&Y)
/*************CHGVAR     VAR(&DISK) VALUE('V' *CAT &Z *CAT 'VDSK') */ /*S01179*/
                   CHGVAR     VAR(&FLDR) VALUE('TFLDR' *CAT &Z)       /*S01179*/
                   GOTO COPY
                 ENDDO
             IF         COND(&Y *EQ 9) THEN(GOTO CMDLBL(ERR))
                    CHGVAR     VAR(&Y) VALUE(&Y + 1)
                    CHGVAR     VAR(&X) VALUE(&X + 10)
                    GOTO LOOP
/*                                                                   */
/**Testkey*package*needs*a*file called BISTKO.INP in the virtual   */ /*S01179*/
/**disk.*This*should*be*created by copying the physical file BISTKI*/ /*S01179*/
/**to*the*virtual*disk.                                            */ /*S01179*/
/*                                                                 */ /*S01179*/
/*OPY:*******CPYTOVDSK**FROMFILE(BISTKIP.&LIB) TOVDSK(&DISK) +    **/ /*S01179*/
/*                        TOPCFILE('BISTKI.INP')                  **/ /*S01179*/
/*                                                                 */ /*S01179*/
/*                                                                 */ /*S01179*/
/*                                                                 */ /*S01179*/
/**Hotkey*to*PC*mode*by*displaying a Hex '3B' in line 2 col 1.     */ /*S01179*/
/*                                                                 */ /*S01179*/
/************CHGVAR*****VAR(&X3B) VALUE(X'3B')                    **/ /*S01179*/
/************SNDF*******RCDFMT(MTC3000F0)                         **/ /*S01179*/
/*                                                                 */ /*S01179*/
/************DLYJOB*****DLY(3)                                    **/ /*S01179*/
/**/
/** Change the message queue so that the message displayed on        */
/** completion of test key calculation is not displayed             */
 COPY:       CHGMSGQ    MSGQ(&NAME) DLVRY(*HOLD)
/*                                                                **/ /*S01179*/
/*********** STRPCCMD   PCCMD(TKIN) PAUSE(*YES)            /*S01179*/ /*067234*/
             STRPCCMD   PCCMD(TKIN) PAUSE(*NO)                        /*067234*/
/*                                                                 */ /*S01179*/
/************CALL       PGM(QCL)                                   */ /*S01179*/
/**/
/** Remove the message sent on completion of the test key calculation*/
/** and revert to message queue in break mode                        */
/**/
             RMVMSG     MSGQ(QSYS/&NAME) CLEAR(*NEW)
             CHGMSGQ    MSGQ(&NAME) DLVRY(*BREAK)
/*                                                                   */
/* After the testkeys are verified, create a copy of TKINPF if not   */
/* present                                                           */
/*                                                                   */
/*           CHKOBJ     OBJ(TKINPF.QTEMP) OBJTYPE(*FILE)   S01179*/
             CHKOBJ     OBJ(QTEMP/TKINPF) OBJTYPE(*FILE) /*S01179*/
             MONMSG     MSGID(CPF9801) EXEC(CRTDUPOBJ OBJ(TKINPF) +
                          FROMLIB(&LIB) OBJTYPE(*FILE) TOLIB(QTEMP))
/**/
/************CPYFRMVDSK*FROMVDSK(&DISK) TOFILE(TKINPF.QTEMP) +     */ /*S01179*/
/*                        FRMPCFILE('TKDEREF.REF') TOMBR(TKINPF)   */ /*S01179*/
/************MONMSG*****MSGID(IWS1541)                             */ /*S01179*/
             CPYFRMPCD  FROMFLR(&FLDR) TOFILE(QTEMP/TKINPF) +
                          FROMDOC(TKDEREF.REF)                        /*S01179*/
             MONMSG     MSGID(IWS1611)                                /*S01179*/
/**/
             DLCOBJ     OBJ((N#ZTK *DTAARA *SHRRD))
/*                                                                   */
/*                                                                   */
/* Call 'Process Incoming Testkey'                                   */
/*                                                                   */
             CALL       PGM(MT3030)
/*                                                                   */
             GOTO       CMDLBL(END)
/*                                                                   */
 ABNOR:      SNDPGMMSG  MSG('Program MTC3030 ended abnormally') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000 IWS0000)
/*                                                                   */
             GOTO       CMDLBL(END)
/*                                                                   */
 ERR:        SNDPGMMSG  MSG('Not authorised to Testkey processing. +
                          Press Enter to continue.') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ)
/*                                                                   */
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
