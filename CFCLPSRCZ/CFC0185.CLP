/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas CF Midas/TRAM transfer subprogram')             */
/*********************************************************************/
/*                                                                   */
/*       Midas - CONFIRMATION MATCHING                               */
/*                                                                   */
/*       CFC0185 -  MIDAS/TRAM INTERFACE CONTROL TRANSFER PROGRAM    */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. 262207             Date 09Oct09              */
/*       Prev Amend No. 247251             Date 22Apr08              */
/*                      CSW051             Date 12Nov07              */
/*                      CCB020             Date 06Aug12              */
/*                      AR796078           Date 28Jun11              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      245314A            Date 29Jun07              */
/*                      245314             Date 02Feb07              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      BUG3557            Date 05Jul04              */
/* Midas Release 4.01.01 --------------------------------------------*/
/*                      207006             Date 18Jun02              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CSW025             Date 06Mar02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      167839             Date 31Jan01              */
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      108872             DATE 12Apr00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      098361             DATE 27APR98              */
/*                      S01408             DATE 14NOV96              */
/*                      CCF001             DATE 12APR95              */
/*                      065979             DATE 05APR94              */
/*                      062640             DATE 17FEB94              */
/*                      062770             DATE 21JAN94              */
/*                      E43951             DATE 30SEP92              */
/*                      E42976             DATE 31JUL92              */
/*                      E40238             DATE 04JUN92              */
/*                      E40688             DATE 04JUN92              */
/*                      E33221             DATE 12DEC91              */
/*                      S01310             DATE 06DEC90              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       262207 - Commit transactions written by CSW052. Otherwise   */
/*                messages may rollback onto the queues.             */
/*       247251 - Do not call CF0120 as MMM sends confs to TRAM      */
/*                instead. Also no need to copy to CFWOCMPD as no    */
/*                longer used and will only create large journals.   */
/*       CSW051 - Send Confirmation from MMM to TRAM                 */
/*       CCB020 - COB Restructure - Secondary COB Infrastructure     */
/*       AR796078 - Applied GEMS 263114.                             */
/*       263114 - CFC0181 failed in COB due to incomplete            */
/*                fix 245314A. Also trap error when folder was not   */
/*                found.                                             */
/*       245314A- Move from /tram/CFFLR.LPZ instead of Qopensys.     */
/*                No need to take out the copy of TRAMHOST.DAT from  */
/*                QDLS to file CFWOCMPD.                             */
/*       245314 - Duplicate Confirmations being sent because         */
/*                condition in CSW025 is not being carried out.      */
/*       BUG3557- Need to trap error if folder is empty              */
/*       207006 - Add Counterparty & Market Centre to SSI            */
/*       CSW025 - Midas Message Manager                              */
/*                The files will be created in a directory under     */
/*                /QOpenSys; simply move them to the relevant folder */
/*                in /QDLS.                                          */
/*   167839 - CFC0181 failed due to object CFWICMPD is locked by     */
/*            other jobs.                                            */
/*   108872 - CFCONTROL loops because TRAM.DAT not deleted when TRAM */
/*            PC not ended correctly due to problems with fix 065979.*/
/*            After 5 loops, check if TRAMHOST.DAT, TRAMSWFT.DAT and */
/*            TRAMCOPY.DAT exist - if not, can delete TRAM.DAT, else */
/*            send message to QSYSOPR giving user option to continue.*/
/*       098361 - MIDAS.DAT in use when trying to copy. Monitor      */
/*                for above messages and retry copy command.         */
/*       S01408 - Addition of core hook CFC0185002                   */
/*              - Addition of core hook CFC0185001                   */
/*       CCF001 - Concord Interface                                  */
/*       065979 - If TRAM.DAT marker exists in folder after 5 loops  */
/*                send message to ask user to check that PC is not   */
/*                in auto mode. Delete marker if it isn't.           */
/*       062640 - Issue ALCOBJ on CFWFEDPD before trying to clear it.*/
/*       062770 - Client download may be running at same time as     */
/*                confo download. Cater for MIDAS.DAT not deleted    */
/*                if other job gets it first. Also monitor for file  */
/*                CFBUSYPD in use, and retry COPY command.           */
/*       E43951 - If error in CFC0060 go to ABNOR - Completes E40688 */
/*       E42976 - CONDITIONING OF SWITCH SETTINGS CHANGED; ORIGINAL  */
/*                VERGING ON THE INCOMPREHENSIBLE, EVEN IF CORRECT.  */
/*       E40238 - REMOVE INCORRECT MONMSG ON CPYFRMPCD FOR           */
/*                TRAMHOST/TRAMSWFT.                                 */
/*       E40688 - THE NEW COB IS DEPENDENCY DRIVEN AND ALL COMPONENTS*/
/*                MUST BE IN THE DEPENDENCY RELATIONS FILE. THIS PGM */
/*                SUBMITS CFC0060 WHICH IS NOT IN THE DEPENDENCY     */
/*                STRUCTURE. REMOVE THIS SUBMISSION AND RUN CFC0060  */
/*                INTERACTIVELY.                                     */
/*       E33221 - SET ON U7 AND U8 IF ERROR CAUSES PROGRAM TO FAIL   */
/*       S01310 - RE WRITTEN FOR SWIFT RATIONALISATION               */
/*       Includes the following fixes:                               */
/*       S01304 - CHECK PC HASN'T STARTED USING FOLDER WHILE         */
/*                AS400 TRYING TO START USING IT                     */
/*       S01259 - SWIFT I RTVJRNE FROM MSIRFPF AND CALL CF0090,      */
/*                SWIFT II RTVJRNE FROM MSIXI2PD AND CALL CF0186     */
/*       S01304 - PROGRAM COPIES FROM PCD TRANSWFT.DAT TO            */
/*                FILE, CALLS CF0090 AND THEN COPIES BACK.           */
/*                IF THE DOCUMENT EXISTS, PROGRAM ENDS IN            */
/*                ERROR.  COPY BACK SHOULD BE REPLACE *YES           */
/*                SEE EQUIVALENT CODE FOR TRAMHOST.DAT.              */
/*                                                                   */
/*********************************************************************/
/*                                                  Start of S01408 */
/*/COPY WNCPYSRC,CFC0185001                                         */
/*                                                    End of S01408 */
             PGM        PARM(&TRAMID &O350 &T350 &MPHAS &GCHAS &RTNVAR)

             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')

             DCL        VAR(&LOOP) TYPE(*DEC) LEN(1 0) VALUE(1)      /*065979*/
             DCL        VAR(&MSGREPLY) TYPE(*CHAR) LEN(1)            /*065979*/
             DCL        VAR(&TRAMID) TYPE(*CHAR) LEN(3)
             DCL        VAR(&O350) TYPE(*CHAR) LEN(1)
             DCL        VAR(&T350) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MPHAS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&GCHAS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTNVAR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&TERM) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FLR) TYPE(*CHAR) LEN(9)
             DCL        VAR(&CMPREC) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTCD) TYPE(*CHAR) LEN(7) VALUE(' ')     /*CCF001*/
             DCL        VAR(&CCF001) TYPE(*CHAR) LEN(1) VALUE(' ')    /*CCF001*/
             DCL        VAR(&CHKMSGRPLY) TYPE(*CHAR) LEN(1)           /*108872*/
             DCL        VAR(&TRAMHOSTF)  TYPE(*CHAR) LEN(1)           /*108872*/
             DCL        VAR(&TRAMSWFTF)  TYPE(*CHAR) LEN(1)           /*108872*/
             DCL        VAR(&TRAMCPTYF)  TYPE(*CHAR) LEN(1)           /*108872*/
             DCL        VAR(&TEMP1) TYPE(*CHAR) LEN(10)               /*167839*/
             DCL        VAR(&TEMP2) TYPE(*CHAR) LEN(10)               /*167839*/
             DCL        VAR(&CSW025) TYPE(*CHAR) LEN(1) VALUE(' ')                        /*CSW025*/
             DCL        VAR(&CPYSTATUS) TYPE(*CHAR) LEN(7)                                /*CSW051*/
             DCL        VAR(&CSW051) TYPE(*CHAR) LEN(1) VALUE(' ')                        /*CSW051*/
             DCL        VAR(&CMTRTN) TYPE(*CHAR) LEN(10)                                  /*262207*/

/* QOpenSys files and QDLS folder strings */                                              /*CSW025*/
             DCL        VAR(&IFSFILES) TYPE(*CHAR) LEN(256)                               /*CSW025*/
             DCL        VAR(&QDLSFLR) TYPE(*CHAR) LEN(256)                                /*CSW025*/
/*/COPY WNCPYSRC,CFC0185012                                          */

/* Global monitor messages                                           */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) +
                          EXEC(GOTO ABNOR)

             CALL (AOSARDR0) PARM(&PRTCD '*VERIFY' 'CSW025')                              /*CSW025*/
             IF (&PRTCD *EQ ' ') (CHGVAR (&CSW025) VALUE('Y'))                            /*CSW025*/

             CALL (AOSARDR0) PARM(&PRTCD '*VERIFY' 'CSW051')                              /*CSW051*/
             IF (&PRTCD *EQ ' ') (CHGVAR (&CSW051) VALUE('Y'))                            /*CSW051*/
                                                                                          /*CSW051*/
/* Notify data area that processing is active */
/**********  IF         COND(&MPHAS *EQ 'A') THEN(CHGDTAARA +
                          DTAARA(CFSTAT (49 6)) VALUE('ACTIVE'))                       */ /*CCB020*/
             IF         COND(&MPHAS *EQ 'A' *OR &MPHAS *EQ 'G') +
                          THEN(CHGDTAARA DTAARA(CFSTAT (49 6)) +
                          VALUE('ACTIVE'))                                                /*CCB020*/

/* Call CF0185 to pick up next TRAM system to action */
 EXDEAL:     CALL       PGM(CF0185) PARM(&TRAMID &TERM)

/* If no TRAM systems remain 'T' returned - exit program */
             IF         COND(&TERM *EQ 'T') THEN(GOTO EXIT)

/*/COPY WNCPYSRC,CFC0185004                                          */
/* If folder does not exist - error */
             CHGVAR     VAR(&FLR) VALUE('CFFLR.' *CAT &TRAMID)

             CRTFLR     FLR(&FLR)
             MONMSG     MSGID(CPF8A85 CPF8A18) EXEC(GOTO CONT)
             GOTO ABNOR

 CONT:       CHKOBJ     OBJ(*LIBL/CFBUSYPD) OBJTYPE(*FILE)

/* For data coming in via Midas Message Manager, the files to process */                  /*CSW025*/
/* will be in a directory in QOpenSys, not a QDLS folder.  We just    */                  /*CSW025*/
/* move everything from the one to the other.                         */                  /*CSW025*/

/**********  IF         COND(&CSW025 = 'Y') THEN(DO)                           /*CSW025*/ /*CSW051*/
             IF         COND((&CSW025 = 'Y') *AND (&CSW051 *NE 'Y')) +
                          THEN(DO)                                                        /*CSW051*/
                                                                                          /*CSW025*/
/**********  CHGVAR     VAR(&IFSFILES) VALUE('/QOpenSys/tram/' *CAT +
                           &FLR *CAT '/*')                                        /*CSW025 245314A*/
             CHGVAR     VAR(&IFSFILES) VALUE('/QOpenSys/tram/' *CAT +
                           &FLR *CAT '/*')                                                /*263114*/
                CHGVAR     VAR(&QDLSFLR) VALUE('/QDLS/' *CAT &FLR)                        /*CSW025*/
                MOVE       OBJ(&IFSFILES) TODIR(&QDLSFLR)                                 /*CSW025*/
             MONMSG     MSGID(CPFA0A0 CPFA0B8) EXEC(SNDMSG +
                          MSG('Duplicate TRAM Host file . Going to +
                          Delay wait.') TOMSGQ(MOPERQ))                                   /*207006*/
             MONMSG     MSGID(CPFA093)                                                   /*BUG3557*/
             MONMSG     MSGID(CPFA0A9)                                                    /*263114*/
             ENDDO       /*CSW025*/
                                                                                          /*CSW025*/
/* Alternatively the data from Message Manager may be coming in from */                   /*CSW051*/
/* a queue. In which case call the program which reads from the queue */                  /*CSW051*/
/* into PF/CFTRAMPD.                                                  */                  /*CSW051*/
             IF         COND((&CSW025 = 'Y') *AND (&CSW051 = 'Y')) +
                          THEN(DO)                                                        /*CSW051*/
                                                                                          /*CSW051*/
             CALL       PGM(SCCMTCTL) PARM('S' &CMTRTN)                                   /*262207*/
             MONMSG     MSGID(CPF8351)                                                    /*262207*/
             CALL       CFG003                                                            /*CSW051*/
             CHGVAR     VAR(&CPYSTATUS) VALUE('PENDING')                                  /*CSW051*/
             CHGVAR     VAR(&QDLSFLR) VALUE(&FLR)                                         /*CSW051*/
             CPYTOPCD   FROMFILE(*LIBL/CFTRAMPD) TOFLR(&QDLSFLR) +
                          TODOC(TRAMHOST.DAT)                                             /*CSW051*/
             MONMSG     MSGID(IWS1612 CPF9999) EXEC(DO)
             SNDMSG     MSG('Duplicate TRAM Host file or path name +
                          not valid. Going to Delay wait.') +
                          TOMSGQ(MOPERQ)                                                  /*CSW051*/
             CHGVAR     VAR(&CPYSTATUS) VALUE('DELAYED')                                  /*CSW051*/
             ENDDO       /*CSW051*/
             MONMSG     MSGID(CPFA093) EXEC(DO)                                           /*CSW051*/
             CHGVAR     VAR(&CPYSTATUS) VALUE('DELAYED')                                  /*CSW051*/
             ENDDO       /*CSW051*/
             IF         COND(&CPYSTATUS *NE 'DELAYED') THEN(CLRPFM +
                          FILE(CFTRAMPD))                                                 /*CSW051*/
             ENDDO       /*CSW051*/
                                                                                          /*CSW051*/
/* Loop until PC is not using folder - TRAM.DAT not found */
RETRY:       CHGVAR     VAR(&LOOP) VALUE(1)                           /*108872*/
 TRY:        CPYFRMPCD  FROMFLR(&FLR) TOFILE(CFBUSYPD) +
                          FROMDOC(TRAM.DAT) MBROPT(*REPLACE) +
                          TRNFMT(*NOTEXT)
             MONMSG     MSGID(CPF3130 CPF4286)  +
                             EXEC(GOTO CMDLBL(TRY))                  /*062770*/
             MONMSG     MSGID(CPF3137) EXEC(GOTO ABNOR)
             MONMSG     MSGID(CPF8A82 IWS168B IWS1611) EXEC(GOTO COPY)
/* */                                                                /*065979*/
/** After 5 loops get user to check that PC is not in auto mode   */ /*065979*/
/** since crashed PC will leave TRAM.DAT behind                   */ /*065979*/
/* */                                                                /*065979*/
             IF         COND(&LOOP *EQ 5) THEN(DO)                   /*065979*/
                 GOTO ENDTRY                                         /*108872*/
             ENDDO                                                   /*108872*/
                                                                     /*108872*/
/********  SNDUSRMSG  MSG('Enter ''C'' to continue if the +
/********                  TRAM PC is no longer in AUTO +
/********                  mode.') TOMSGQ(*EXT) +
/********                  MSGRPY(&MSGREPLY)                   /*065979 108872*/
/********  IF         COND((&MSGREPLY *EQ 'C') *OR (&MSGREPLY +
/********             *EQ 'c')) THEN(DO)                      +       /*108872*/
/********             DLTDLO DLO(TRAM.DAT) FLR(&FLR)          +       /*108872*/
/********    CHGVAR     VAR(&LOOP) VALUE(1)                   +       /*065979*/
/********    ENDDO                                             /*065979 108872*/
                                                                      /*108872*/
             CHGVAR     VAR(&LOOP) VALUE(&LOOP + 1)                  /*065979*/
                                                                      /*108872*/
/* If TRAM.DAT exists then wait a minute for PC to access the      */ /*108872*/
/* folder otherwise the repeated copy can lock out the PC with a   */ /*108872*/
/* Sharing Violation.                                              */ /*108872*/
             DLYJOB     DLY(60)                                       /*108872*/
             GOTO TRY

ENDTRY:                                                               /*108872*/
/* After 5 loops check if TRAMHOST.DAT, TRAMSWFT.DAT and                108872*/
/* TRAMCPTY.DAT exist.  If they don't, it is safe to delete             108872*/
/* TRAM.DAT.  If they do, send message to QSYSOPR to see if TRAM        108872*/
/* PC is in AUTO.  If not, delete TRAM.DAT but warn QSYSOPR that        108872*/
/* TRAM was not closed properly.                                        108872*/
             IF  (&LOOP *LT 5) THEN(DO)                               /*108872*/
                 GOTO COPY                                            /*108872*/
                 ENDDO                                                /*108872*/
             CHGVAR  &CHKMSGRPLY VALUE(' ')                           /*108872*/

CHECKDOC:    CHGVAR  &TRAMHOSTF VALUE('Y')                            /*108872*/
             CHGVAR  &TRAMSWFTF VALUE('Y')                            /*108872*/
             CHGVAR  &TRAMCPTYF VALUE('Y')                            /*108872*/

             CHKDLO  DLO(TRAMHOST.DAT) FLR(&FLR)                      /*108872*/
             MONMSG (CPF8A82) +
                    EXEC(CHGVAR &TRAMHOSTF VALUE('N'))                /*108872*/

             CHKDLO  DLO(TRAMSWFT.DAT) FLR(&FLR)                      /*108872*/
             MONMSG (CPF8A82) +
                    EXEC(CHGVAR &TRAMSWFTF VALUE('N'))                /*108872*/

             CHKDLO  DLO(TRAMCPTY.DAT) FLR(&FLR)                      /*108872*/
             MONMSG (CPF8A82) +
                    EXEC(CHGVAR &TRAMCPTYF VALUE('N'))                /*108872*/

/* If the other documents do not exist then delete TRAM.DAT marker    /*108872*/
             IF   ((&TRAMHOSTF *EQ 'N') *AND +
                   (&TRAMSWFTF *EQ 'N') *AND +
                   (&TRAMCPTYF *EQ 'N')) THEN(DO)                     /*108872*/
                  GOTO DLTDOC                                         /*108872*/
                  ENDDO                                               /*108872*/

/* If the 'Continue' reply was taken to the 'Check PC not in Auto'    /*108872*/
/* message. (And there other documents still exist i.e PC not now     /*108872*/
/* taken out of AUTO mode). Then delete TRAM.DAT marker               /*108872*/
             IF   (&CHKMSGRPLY *EQ 'C') THEN(DO)                      /*108872*/
                  GOTO DLTDOC                                         /*108872*/
                  ENDDO                                               /*108872*/

/* Send message and await for reply. When reply received the document   108872*/
/* PC maybe not be using the folder any more. If it still is then       108872*/
/* recheck which other Folders are present. If reply is not Continue    108872*/
/* then go back to check if PC using FLR                                108872*/
             SNDUSRMSG  MSG('Please check that TRAM PC is not in +
                          AUTO mode.Enter ''C'' to continue if it +
                          is not') TOMSGQ(MOPERQ) +
                          MSGRPY(&MSGREPLY)                           /*108872*/
             CPYFRMPCD  FROMFLR(&FLR) TOFILE(CFBUSYPD) +
                          FROMDOC(TRAM.DAT) MBROPT(*REPLACE) +
                          TRNFMT(*NOTEXT)                             /*108872*/
                 MONMSG  (CPF3137) EXEC(GOTO ABNOR)                   /*108872*/
                 MONMSG  (CPF8A82 IWS168B IWS1611) EXEC(GOTO COPY)    /*108872*/

             IF   ((&MSGREPLY *EQ 'C') *OR +
                   (&MSGREPLY *EQ 'c')) THEN(DO)                      /*108872*/
                   CHGVAR &CHKMSGRPLY VALUE('C')                      /*108872*/
                   GOTO CHECKDOC                                      /*108872*/
                   ENDDO                                              /*108872*/
             ELSE (DO)                                                /*108872*/
                   CHGVAR &CHKMSGRPLY VALUE(&MSGREPLY)                /*108872*/
                   GOTO RETRY                                         /*108872*/
                   ENDDO                                              /*108872*/

DLTDOC:
            DLTDLO  DLO(TRAM.DAT) FLR(&FLR)                           /*108872*/
            MONMSG (CPF8A82 CPF8A16)  EXEC(GOTO COPY)                 /*108872*/

/* If TRAM.DAT deleted here then send messages to MOPERQ for            108872*/
/* diagnostics                                                          108872*/
            SNDPGMMSG  MSG('TRAM PC was taken out of Auto mode +
                    incorrectly - please ask TRAM users to +
                    check their files are correct') +
                    TOMSGQ(MOPERQ)                                    /*108872*/
            SNDPGMMSG  MSG('TRAM.DAT document still existed +
                     and was deleted in CFC0185')   +
                     TOMSGQ(MOPERQ)                                   /*108872*/
            IF (&TRAMHOSTF *EQ 'Y') THEN(DO)                          /*108872*/
                SNDPGMMSG  MSG('TRAMHOST.DAT document existed +
                     when Message was answered in CFC0185')   +
                     TOMSGQ(MOPERQ)                                   /*108872*/
                ENDDO                                                 /*108872*/
            IF (&TRAMSWFTF *EQ 'Y') THEN(DO)                          /*108872*/
                SNDPGMMSG  MSG('TRAMSWFT.DAT document existed +
                     when Message was answered in CFC0185')   +
                     TOMSGQ(MOPERQ)                                   /*108872*/
                ENDDO                                                 /*108872*/
            IF (&TRAMCPTYF *EQ 'Y') THEN(DO)                          /*108872*/
                SNDPGMMSG  MSG('TRAMCPTY.DAT document existed +
                     when Message was answered in CFC0185')   +
                     TOMSGQ(MOPERQ)                                   /*108872*/
                ENDDO                                                 /*108872*/

/* Allocate folder by creating MIDAS.DAT document */
 COPY:      CPYTOPCD  FROMFILE(*LIBL/CFBUSYPD) TOFLR(&FLR) +
                      TODOC(MIDAS.DAT) REPLACE(*YES) TRNFMT(*NOTEXT)
             MONMSG     MSGID(CPF8A80 IWS16B9 IWS1612) +
                          EXEC(DO)                                   /*098361*/
             DLYJOB     DLY(30)                                      /*098361*/
             GOTO       TRY                                          /*098361*/
             ENDDO                                                   /*098361*/

/* Check that PC hasn't started using the folder whilst AS/400 */
/* was trying to start using it.                               */
             DLYJOB     DLY(60)
             CPYFRMPCD  FROMFLR(&FLR) TOFILE(CFBUSYPD) +
                          FROMDOC(TRAM.DAT) MBROPT(*REPLACE) +
                          TRNFMT(*NOTEXT)
             MONMSG     MSGID(CPF3130 CPF4286)                       /*062770*/
             MONMSG     MSGID(CPF3137) EXEC(GOTO CMDLBL(ABNOR))
             MONMSG     MSGID(CPF8A82 IWS168B IWS1611) EXEC(GOTO CONT2)

/* If copy successful, TRAM.DAT exists and PC is busy,      */
/* so delete MIDAS.DAT document just created and try again. */
             DLTDLO     DLO(MIDAS.DAT) FLR(&FLR)
             MONMSG     MSGID(CPF8A82 CPF8A16)                       /*062770*/
             GOTO TRY

/* Clear temporary file  */
/****CONT2:       CLRPFM     FILE(CFWOCMPD)           */           /*247251*/
CONT2:       IF (&CSW025 *NE 'Y') THEN(DO)                         /*247251*/
             CLRPFM     FILE(CFWOCMPD)                             /*247251*/

/* If folder has not been collected, copy back to file to add new ones */
             CPYFRMPCD  FROMFLR(&FLR) TOFILE(CFWOCMPD) +
                          FROMDOC(TRAMHOST.DAT) TRNFMT(*NOTEXT)
/************MONMSG     MSGID(CPF8A82 IWS1602 IWS16B8 IWS1611) + **** E40238 */
/*************************EXEC(GOTO EMPTY)  ************************* E40238 */
                                                                   /* E40238 */
             MONMSG     MSGID(CPF8A82 IWS16B8 IWS1611) +
                          EXEC(GOTO EMPTY)                         /* E40238 */
                                                                   /* E40238 */
             CHGVAR     VAR(&CMPREC) VALUE(Y)
             GOTO FULL

 EMPTY:      CHGVAR     VAR(&CMPREC) VALUE(N)

/* Call CF0120 to extract outgoing messages */
/*/COPY WNCPYSRC,CFC0185005                                          */
/**********  IF         COND(&CSW025 *NE 'Y') THEN(DO)                             /*CSW025 245314*/
 FULL:       IF         COND(&CSW025 *NE 'Y') THEN(DO)                                    /*245314*/
/*FULL:****  CALL       PGM(CF0120) PARM(&TRAMID &O350 &CMPREC)                           /*245314*/
             CALL       PGM(CF0120) PARM(&TRAMID &O350 &CMPREC)                           /*245314*/
             ENDDO                                                                        /*CSW025*/
/*/COPY WNCPYSRC,CFC0185006                                          */
/*********** IF         COND(%SWITCH(XXXXXX00) *NE '1') THEN(GOTO +1 E42976 */
             IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO +
                          CMDLBL(ABNOR))                           /* E42976 */
             IF         COND(%SWITCH(XXXXXXX1)) THEN(GOTO +
                          CMDLBL(ABNOR))                           /* E42976 */

/*/COPY WNCPYSRC,CFC0185013                                          */
/**********  CPYTOPCD   FROMFILE(CFWOCMPD) TOFLR(&FLR) +
/**********               TODOC(TRAMHOST.DAT) REPLACE(*YES) +
/**********               TRNFMT(*NOTEXT)                                                /*245314A*/
              ENDDO       /*247251*/
/*/COPY WNCPYSRC,CFC0185014                                          */
                                                                     /*CCF001*/
                                                                     /*CCF001*/
/** Add processing for ConCord                                    */ /*CCF001*/
                                                                     /*CCF001*/
             CALL (AOSARDR0) PARM(&PRTCD '*VERIFY' 'CCF001')         /*CCF001*/
             IF (&PRTCD *EQ ' ') (CHGVAR (&CCF001) VALUE('Y'))       /*CCF001*/
/**/                                                                 /*CCF001*/
/*   If feature CCF001 is ON:                                     */ /*CCF001*/
/**/                                                                 /*CCF001*/
             IF COND(&CCF001 *EQ 'Y') THEN(DO)                       /*CCF001*/
/**/                                                                 /*CCF001*/
                                                                     /*CCF001*/
                                                                     /*CCF001*/
/* Clear temporary file  */                                          /*CCF001*/
             CLRPFM     FILE(CFCONCPD)                               /*CCF001*/
                                                                     /*CCF001*/
/*If folder has not been collected, copy back to file to add new ones  CCF001*/
             CPYFRMPCD  FROMFLR(&FLR) TOFILE(CFCONCPD) +
                          FROMDOC(CONCORD.DAT) TRNFMT(*NOTEXT)       /*CCF001*/
                                                                   /*/*CCF001*/
             MONMSG     MSGID(CPF8A82 IWS16B8 IWS1611) +
                          EXEC(GOTO EMPTY3)                        /*/*CCF001*/
                                                                   /*/*CCF001*/
             CHGVAR     VAR(&CMPREC) VALUE(Y)                        /*CCF001*/
             GOTO FULL3                                              /*CCF001*/
EMPTY3:      CHGVAR     VAR(&CMPREC) VALUE(N)                        /*CCF001*/
                                                                     /*CCF001*/
/* Rename document to stop duplication */                            /*CCF001*/
FULL3:       RNMDLO     DLO(CONCORD.DAT) NEWDLO(CONCWRK.DAT) +
                        FLR(&FLR)                                    /*CCF001*/
             MONMSG     MSGID(CPF8A82 CPF8A14 IWS1611)
                                                                   /*/*CCF001*/
/* Call CF0121 to extract outgoing messages */                       /*CCF001*/
/*/COPY WNCPYSRC,CFC0185007                                          */
             IF         COND(&CSW025 *NE 'Y') THEN(DO)                                    /*CSW025*/
             CALL       PGM(CF0121) PARM(&TRAMID &CMPREC)            /*CCF001*/
             ENDDO                                                                        /*CSW025*/
/*/COPY WNCPYSRC,CFC0185008                                          */
             IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)
             RNMDLO     DLO(CONCWRK.DAT) NEWDLO(CONCORD.DAT) FLR(&FLR)
                   GOTO CMDLBL(ABNOR)                              /*/*CCF001*/
             ENDDO                                                   /*CCF001*/
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
             RNMDLO     DLO(CONCWRK.DAT) NEWDLO(CONCORD.DAT) FLR(&FLR)
                   GOTO CMDLBL(ABNOR)                              /*/*CCF001*/
             ENDDO                                                   /*CCF001*/
                                                                     /*CCF001*/
             CPYTOPCD   FROMFILE(CFCONCPD) TOFLR(&FLR) +
                          TODOC(CONCWRK.DAT) REPLACE(*YES) +
                          TRNFMT(*NOTEXT)                            /*CCF001*/
                                                                     /*CCF001*/
             RNMDLO     DLO(CONCWRK.DAT) NEWDLO(CONCORD.DAT) FLR(&FLR)
                                                                     /*CCF001*/
             MONMSG     MSGID(CPF8A82) +
                          EXEC(GOTO ABNOR)                         /*/*CCF001*/
             ENDDO                                                   /*CCF001*/
                                                                     /*CCF001*/
             CHGDTAARA  DTAARA(CFSTAT (1 3)) VALUE(&TRAMID)

/* Clear temporary file  */
             CLRPFM     FILE(CFWICMPD)

/* If folder has not been collected, copy back to file to add new ones */
             CPYFRMPCD  FROMFLR(&FLR) TOFILE(CFWICMPD) +
                          FROMDOC(TRAMSWFT.DAT) TRNFMT(*NOTEXT)
/************MONMSG     MSGID(CPF8A82 IWS1602 IWS16B8 IWS1611) + ***** E40238 */
/*************************EXEC(GOTO EMPTY2) ************************** E40238 */
                                                                    /* E40238 */
             MONMSG     MSGID(CPF8A82 IWS16B8 IWS1611) +
                          EXEC(GOTO EMPTY2)                         /* E40238 */
                                                                    /* E40238 */
             CHGVAR     VAR(&CMPREC) VALUE(Y)
             GOTO FULL2

 EMPTY2:     CHGVAR     VAR(&CMPREC) VALUE(N)

/**/                                                                /*167839*/
/*Try to allocate file CFWICMPD before calling CF0186*/             /*167839*/
/**/                                                                /*167839*/
 FULL2:      ALCOBJ     OBJ((CFWICMPD *FILE *EXCL)) WAIT(180)       /*167839*/
             MONMSG     MSGID(CPF1002) EXEC(DO)                     /*167839*/
             RTVJOBA    OUTQ(&TEMP1) OUTQLIB(&TEMP2)                /*167839*/
             CHGJOB     OUTQ(*LIBL/MPRINTAU)                        /*167839*/
             WRKOBJLCK  OBJ(CFWICMPD) OBJTYPE(*FILE) OUTPUT(*PRINT) /*167839*/
             CHGJOB     OUTQ(&TEMP2/&TEMP1)                         /*167839*/
             CHGJOB     SWS(XXXXXX11)                               /*167839*/
             GOTO       CMDLBL(ALC_ERR)                             /*167839*/
             ENDDO                                                  /*167839*/
/**/                                                                /*167839*/
/* Call CF0186 to extract Incoming Messages. */
/***FULL2:****CALL       PGM(CF0186) PARM(&TRAMID &T350 &CMPREC)*/  /*167839*/
             CALL       PGM(CF0186) PARM(&TRAMID &T350 &CMPREC)     /*167839*/
/*********** IF         COND(%SWITCH(XXXXXX00) *NE '1') THEN(GOTO ABNOR)E42976*/
             IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO +
                          CMDLBL(ABNOR))                            /* E42976 */
             IF         COND(%SWITCH(XXXXXXX1)) THEN(GOTO +
                          CMDLBL(ABNOR))                            /* E42976 */

             CPYTOPCD   FROMFILE(CFWICMPD) TOFLR(&FLR) +
                          TODOC(TRAMSWFT.DAT) REPLACE(*YES) +
                          TRNFMT(*NOTEXT) /*S01304*/
             CHGDTAARA  DTAARA(CFSTAT (4 3)) VALUE(&TRAMID)

/* Copy feedback */
             CPYFRMPCD  FROMFLR(&FLR) TOFILE(CFWFEDPD) +
                          FROMDOC(TRAMFEED.DAT) MBROPT(*ADD)
/**********  MONMSG     MSGID(CPF8A82 IWS1602 IWS16B8 IWS1611)        /*108872*/
            MONMSG     MSGID(CPF8A82 IWS1602 IWS16B8 IWS1611 IWS1603) /*108872*/
             DLTDLO     DLO(TRAMFEED.DAT) FLR(&FLR)
             MONMSG     MSGID(CPF8A82 CPF8A16)
/*/COPY WNCPYSRC,CFC0185003                                          */
             DLTDLO     DLO(MIDAS.DAT) FLR(&FLR)
             MONMSG     MSGID(CPF8A82 CPF8A16)

/* End of loop for each TRAM system */
             GOTO EXDEAL

/*/COPY WNCPYSRC,CFC0185009                                          */
 EXIT:       CALL       PGM(CF0140)
/*/COPY WNCPYSRC,CFC0185010                                          */
/*********** IF         COND(%SWITCH(XXXXXX00) *NE '1') THEN(GOTO ABNOR)E42976*/
             IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO +
                          CMDLBL(ABNOR))                            /* E42976 */
             IF         COND(%SWITCH(XXXXXXX1)) THEN(GOTO +
                          CMDLBL(ABNOR))                            /* E42976 */
/*/COPY WNCPYSRC,CFC0185011                                          */
             ALCOBJ     OBJ((CFWFEDPD *FILE *EXCL *FIRST)) WAIT(60)  /*062640*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                             CMDLBL(ALC_ERR))                        /*062640*/
             CLRPFM     FILE(CFWFEDPD)
             DLCOBJ     OBJ((CFWFEDPD *FILE *EXCL *FIRST))           /*062640*/

/* Generate Chasers for Timed out Confirmations if required */
             IF         COND(&GCHAS *EQ 'Y') THEN(DO)
/************SBMJOB     CMD(CALL PGM(CFC0060)) JOB(CHASERS) +      */ /*E40688*/
/************             JOBD(MBATCH) JOBQ(CFJOBQB)               */ /*E40688*/
             CALL PGM(CFC0060)                                        /*E40688*/
             IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO +
                          CMDLBL(ABNOR))                             /*E43951*/
             IF         COND(%SWITCH(XXXXXXX1)) THEN(GOTO +
                          CMDLBL(ABNOR))                             /*E43951*/
             ENDDO

             GOTO END
 ALC_ERR:    CHGVAR     VAR(&RTNVAR) VALUE('1')                      /*062640*/
             SNDPGMMSG  MSG('Cannot allocate object CFWFEDPD') +
                             TOMSGQ(MOPERQ MRUNQ)                    /*062640*/
             GOTO       CMDLBL(END)                                  /*062640*/
 ABNOR:      CHGVAR     VAR(&RTNVAR) VALUE('1')
             CHGJOB     SWS(XXXXXX11)                         /*E33221*/

             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')

 END:        ENDPGM
/*                                                  Start of S01408 */
/*/COPY WNCPYSRC,CFC0185002                                         */
/*                                                    End of S01408 */

