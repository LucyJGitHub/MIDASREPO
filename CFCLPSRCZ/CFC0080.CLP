/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas CF Client Download')                            */
/*********************************************************************/
/*                                                                   */
/*       Midas     - CONFIRMATION MATCHING                           */
/*                                                                   */
/*       CFC0080 - DOWNLOAD CLIENT DETAILS TO TRAM                   */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      113734             Date 06Jun06              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      098361             DATE 27APR98              */
/*                      063524             DATE 01MAR94              */
/*                      062770             DATE 2OJAN94              */
/*                      S01310             DATE 25JUL91              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CLE134 - Past Due Call Loan Processing (Recompile)          */
/*       113734 - As in CFC0185, see if other PC files are present.  */
/*                If they aren't, delete TRAM.DAT.  If they are,     */
/*                inform QSYSOPR and allow a reply that will delete  */
/*                it, and inform QSYSOPR to further investigate.     */
/*                Applied as per fix 113209 in CFC0185               */
/*       098361 - TRAM.DAT in use when trying to copy. Monitor       */
/*                for above messages and retry copy command.         */
/*       063524 - Insert a delay job command, looping/retry too fast */
/*                for the PC to delete control files.                */
/*       062770 - Client download may be running at same time as     */
/*                confo download. Cater for MIDAS.DAT not deleted if */
/*                other job gets it first. Also monitor for file     */
/*                CFBUSYPD in use, and retry COPY command.           */
/*       S01310 - RE WRITTEN FOR SWIFT RATIONALISATION               */
/*       Includes the following fixes:                               */
/*       S01304 - CHANGES MADE FOR CONFIRMATION MATCHING INC.        */
/*       S01184 - CREATED FOR CONFIRMATION MATCHING                  */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&FLR)
 
             DCL        VAR(&FLR)      TYPE(*CHAR) LEN(3)
             DCL        VAR(&SAVIMID)  TYPE(*CHAR) LEN(3)
             DCL        VAR(&FOLDER)   TYPE(*CHAR) LEN(9)
             DCL        VAR(&RUND)     TYPE(*CHAR) LEN(5)
             DCL        VAR(&CHKMSGRPLY) TYPE(*CHAR) LEN(1)                               /*113734*/
             DCL        VAR(&TRAMHOSTF)  TYPE(*CHAR) LEN(1)                               /*113734*/
             DCL        VAR(&TRAMSWFTF)  TYPE(*CHAR) LEN(1)                               /*113734*/
             DCL        VAR(&TRAMCPTYF)  TYPE(*CHAR) LEN(1)                               /*113734*/
             DCL        VAR(&TRYMAX)   TYPE(*DEC)  LEN(2 0) VALUE(5)                      /*113734*/
             DCL        VAR(&LOOP) TYPE(*DEC) LEN(1 0) VALUE(1)                           /*113734*/
             DCL        VAR(&MSGREPLY) TYPE(*CHAR) LEN(1)                                 /*113734*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             DCLF       FILE(CFBRCHL0)
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ERROR))
 
             CHGJOB     SWS(00000000)
 
/* clear client extract file */
             CLRPFM     FILE(*LIBL/CFCLNTPD)
 
/* extract client details from SDCUSTPD to be downloaded to PC */
             CALL       PGM(*LIBL/CF0080) PARM(&FLR)
 
/* if no records were output to CFCLNTPD by CF0080, then exit  */
/* (attempt to copy to workfile CFWCLNPD to find if empty)     */
/* CPF2869 => no records in CFCLNTPD (CFWCLNPD exists) - exit  */
/* CPC2957 => no records in CFCLNTPD (CFWCLNPD created) - exit */
 
             CHKOBJ     OBJ(CFCLNTPD) OBJTYPE(*FILE)
 
             DLTF (QTEMP/CFWCLNPD)
             MONMSG MSGID(CPF0000)
 
             CPYF       FROMFILE(*LIBL/CFCLNTPD) +
                        TOFILE(QTEMP/CFWCLNPD) MBROPT(*REPLACE) +
                        CRTFILE(*YES) FROMRCD(1) TORCD(1)
             MONMSG     MSGID(CPF2869) EXEC(GOTO +
                           CMDLBL(END))
 
/* if new TRAM system to be added, send details to it only */
/* empty CFCLNTPD => TRAMCPTY.DAT created empty            */
             IF         COND((&FLR *NE ZZZ) *AND (&FLR *NE '   ')) +
                        THEN(DO)
                CHGVAR     VAR(&FOLDER) VALUE('CFFLR.' *CAT &FLR)
                CRTFLR     FLR(&FOLDER)
                MONMSG     MSGID(CPF8A85 CPF8A18)
 
                CHKOBJ     OBJ(*LIBL/CFBUSYPD) OBJTYPE(*FILE)
 
/* loop until PC is not using folder                     */
/* if TRAM.DAT not found, the PC is not using the folder */
RETRY:       CHGVAR     VAR(&LOOP) VALUE(1)                                               /*113734*/
TRY:            CPYFRMPCD  FROMFLR(&FOLDER) TOFILE(CFBUSYPD) +
                           FROMDOC(TRAM.DAT) MBROPT(*REPLACE) +
                           TRNFMT(*NOTEXT)
/************MONMSG     MSGID(CPF3130 CPF4286)  +          */ /*062770 063524*/
/************                EXEC(GOTO CMDLBL(TRY))        */ /*062770 063524*/
/************MONMSG     MSGID(CPF3130 CPF4286) EXEC(DO)       /*063524 098361*/
             MONMSG     MSGID(CPF3130 CPF4286 CPF8A80 IWS16B8) +
                          EXEC(DO)                                   /*098361*/
                  DLYJOB     DLY(30)                                 /*063524*/
                  GOTO       TRY                                     /*063524*/
             ENDDO                                                   /*063524*/
                MONMSG     MSGID(CPF3137) EXEC(GOTO CMDLBL(ERROR))
                MONMSG     MSGID(CPF8A82 IWS168B IWS1611) EXEC(GOTO +
                           CMDLBL(COPY))
                                                                                          /*113734*/
             IF  COND(&LOOP *EQ &TRYMAX) THEN(DO)                                         /*113734*/
                 GOTO ENDTRY                                                              /*113734*/
             ENDDO                                                                        /*113734*/
             CHGVAR     VAR(&LOOP) VALUE(&LOOP + 1)                                       /*113734*/
 
/* */                                                                /*063524*/
/** Delay job for 30 seconds to allow PC access to file           */ /*063524*/
/* */                                                                /*063524*/
             DLYJOB     DLY(30)                                      /*063524*/
/* copy successful => TRAM.DAT exists => PC is busy so try again */
                GOTO TRY
 
ENDTRY:                                                                                   /*113734*/
/* After 5 loops check if TRAMHOST.DAT, TRAMSWFT.DAT and                                    113734*/
/* TRAMCPTY.DAT exist.  If they don't, it is safe to delete                                 113734*/
/* TRAM.DAT.  If they do, send message to QSYSOPR to see if TRAM                            113734*/
/* PC is in AUTO.  If not, delete TRAM.DAT but warn QSYSOPR that                            113734*/
/* TRAM was not closed properly.                                                            113734*/
             IF  (&LOOP *LT &TRYMAX) THEN(DO)                                             /*113734*/
                 GOTO COPY                                                                /*113734*/
                 ENDDO                                                                    /*113734*/
             CHGVAR  &CHKMSGRPLY VALUE(' ')                                               /*113734*/
                                                                                          /*113734*/
CHECKDOC:    CHGVAR  &TRAMHOSTF VALUE('Y')                                                /*113734*/
             CHGVAR  &TRAMSWFTF VALUE('Y')                                                /*113734*/
             CHGVAR  &TRAMCPTYF VALUE('Y')                                                /*113734*/
                                                                                          /*113734*/
             CHKDLO  DLO(TRAMHOST.DAT) FLR(&FLR)                                          /*113734*/
             MONMSG (CPF8A82) +
                    EXEC(CHGVAR &TRAMHOSTF VALUE('N'))                                    /*113734*/
                                                                                          /*113734*/
             CHKDLO  DLO(TRAMSWFT.DAT) FLR(&FLR)                                          /*113734*/
             MONMSG (CPF8A82) +
                    EXEC(CHGVAR &TRAMSWFTF VALUE('N'))                                    /*113734*/
                                                                                          /*113734*/
             CHKDLO  DLO(TRAMCPTY.DAT) FLR(&FLR)                                          /*113734*/
             MONMSG (CPF8A82) +
                    EXEC(CHGVAR &TRAMCPTYF VALUE('N'))                                    /*113734*/
                                                                                          /*113734*/
/* If the other documents do not exist then delete TRAM.DAT marker                        /*113734*/
             IF   ((&TRAMHOSTF *EQ 'N') *AND +
                   (&TRAMSWFTF *EQ 'N') *AND +
                   (&TRAMCPTYF *EQ 'N')) THEN(DO)                                         /*113734*/
                  GOTO DLTDOC                                                             /*113734*/
                  ENDDO                                                                   /*113734*/
 
/* If the 'Continue' reply was taken to the 'Check PC not in Auto'                        /*113734*/
/* message. (And there other documents still exist i.e PC not now                         /*113734*/
/* taken out of AUTO mode). Then delete TRAM.DAT marker                                   /*113734*/
             IF   (&CHKMSGRPLY *EQ 'C') THEN(DO)                                          /*113734*/
                  GOTO DLTDOC                                                             /*113734*/
                  ENDDO                                                                   /*113734*/
                                                                                          /*113734*/
/* Send message and await for reply. When reply received the document                       113734*/
/* PC maybe not be using the folder any more. If it still is then                           113734*/
/* recheck which other Folders are present. If reply is not Continue                        113734*/
/* then go back to check if PC using FLR                                                    113734*/
             SNDUSRMSG  MSG('Please check that TRAM PC is not in +
                          AUTO mode.Enter ''C'' to continue if it +
                          is not') TOMSGQ(MOPERQ) +
                          MSGRPY(&MSGREPLY)                                               /*113734*/
             CPYFRMPCD  FROMFLR(&FLR) TOFILE(CFBUSYPD) +
                          FROMDOC(TRAM.DAT) MBROPT(*REPLACE) +
                          TRNFMT(*NOTEXT)                                                 /*113734*/
                 MONMSG  (CPF3137) EXEC(GOTO ERROR)                                       /*113734*/
                 MONMSG  (CPF8A82 IWS168B IWS1611) EXEC(GOTO COPY)                        /*113734*/
                                                                                          /*113734*/
             IF   ((&MSGREPLY *EQ 'C') *OR +
                   (&MSGREPLY *EQ 'c')) THEN(DO)                                          /*113734*/
                   CHGVAR &CHKMSGRPLY VALUE('C')                                          /*113734*/
                   GOTO CHECKDOC                                                          /*113734*/
                   ENDDO                                                                  /*113734*/
             ELSE (DO)                                                                    /*113734*/
                   CHGVAR &CHKMSGRPLY VALUE(&MSGREPLY)                                    /*113734*/
                   GOTO RETRY                                                             /*113734*/
                   ENDDO                                                                  /*113734*/
                                                                                          /*113734*/
/* following line should not get executed but just a fail safe                              113734*/
/* the only way to get to DLTDOC is from the GOTOs above                                    113734*/
            GOTO   COPY                                                                   /*113734*/
                                                                                          /*113734*/
DLTDOC:                                                                                   /*113734*/
            DLTDLO  DLO(TRAM.DAT) FLR(&FLR)                                               /*113734*/
            MONMSG (CPF8A82 CPF8A16)  EXEC(GOTO COPY)                                     /*113734*/
                                                                                          /*113734*/
/* If TRAM.DAT deleted here then send messages to MOPERQ for                                113734*/
/* diagnostics                                                                              113734*/
            SNDPGMMSG  MSG('TRAM PC was taken out of Auto mode +
                    incorrectly - please ask TRAM users to +
                    check their files are correct') +
                    TOMSGQ(MOPERQ)                                                        /*113734*/
            SNDPGMMSG  MSG('TRAM.DAT document still existed +
                     and was deleted in CFC0185')   +
                     TOMSGQ(MOPERQ)                                                       /*113734*/
            IF (&TRAMHOSTF *EQ 'Y') THEN(DO)                                              /*113734*/
                SNDPGMMSG  MSG('TRAMHOST.DAT document existed +
                     when Message was answered in CFC0185')   +
                     TOMSGQ(MOPERQ)                                                       /*113734*/
                ENDDO                                                                     /*113734*/
            IF (&TRAMSWFTF *EQ 'Y') THEN(DO)                                              /*113734*/
                SNDPGMMSG  MSG('TRAMSWFT.DAT document existed +
                     when Message was answered in CFC0185')   +
                     TOMSGQ(MOPERQ)                                                       /*113734*/
                ENDDO                                                                     /*113734*/
            IF (&TRAMCPTYF *EQ 'Y') THEN(DO)                                              /*113734*/
                SNDPGMMSG  MSG('TRAMCPTY.DAT document existed +
                     when Message was answered in CFC0185')   +
                     TOMSGQ(MOPERQ)                                                       /*113734*/
                ENDDO                                                                     /*113734*/
                                                                                          /*113734*/
/* allocate folder by creating MIDAS.DAT document */
COPY:           CPYTOPCD   FROMFILE(*LIBL/CFBUSYPD) TOFLR(&FOLDER) +
                           TODOC(MIDAS.DAT) REPLACE(*YES) +
                           TRNFMT(*NOTEXT)
 
                CPYTOPCD   FROMFILE(*LIBL/CFCLNTPD) TOFLR(&FOLDER) +
                           TODOC(TRAMCPTY.DAT) REPLACE(*YES) +
                           TRNFMT(*TEXT)
 
/* deallocate folder by removing MIDAS.DAT document */
                DLTDLO     DLO(MIDAS.DAT) FLR(&FOLDER)
             MONMSG     MSGID(CPF8A82 CPF8A16)                       /*062770*/
                GOTO       CMDLBL(END)
                ENDDO
 
/* ELSE it must be installation ('ZZZ') or daily download ('   ') */
             ELSE       CMD(DO)
 
/* start with empty work file */
NEXTTRAM:       CLRPFM     FILE(QTEMP/CFWCLNPD)
 
/* find next new TRAM ID on CFBRCHL0 (TRAM/BRANCH file) */
NEXTREC:        RCVF       WAIT(*YES)
 
/* End of CFBRCHL0 file, update DTAARA/CFSTAT with run date */
                MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(UPDATE))
 
/* loop until a new TRAM id is read */
                IF         COND(&IMID *EQ &SAVIMID) THEN(GOTO +
                           CMDLBL(NEXTREC))
 
                CHGVAR     VAR(&FOLDER) VALUE('CFFLR.' *CAT &IMID)
                CRTFLR     FLR(&FOLDER)
                MONMSG     MSGID(CPF8A85 CPF8A18)
 
                CHKOBJ     OBJ(*LIBL/CFBUSYPD) OBJTYPE(*FILE)
 
/* loop until PC is not using folder                     */
/* if TRAM.DAT not found, the PC is NOT using the folder */
RETRY2:      CHGVAR     VAR(&LOOP) VALUE(1)                                               /*113734*/
TRY2:           CPYFRMPCD  FROMFLR(&FOLDER) TOFILE(CFBUSYPD) +
                           FROMDOC(TRAM.DAT) MBROPT(*REPLACE) +
                           TRNFMT(*NOTEXT)
/************MONMSG     MSGID(CPF3130 CPF4286)  +          */ /*062770 063524*/
/************                EXEC(GOTO CMDLBL(TRY2))       */ /*062770 063524*/
             MONMSG     MSGID(CPF3130 CPF4286) EXEC(DO)              /*063524*/
                  DLYJOB     DLY(30)                                 /*063524*/
                  GOTO       TRY2                                    /*063524*/
             ENDDO                                                   /*063524*/
                MONMSG     MSGID(CPF3137) EXEC(GOTO CMDLBL(ERROR))
                MONMSG     MSGID(CPF8A82 IWS168B IWS1611) EXEC(GOTO +
                           CMDLBL(COPY2))
                                                                                          /*113734*/
             IF  COND(&LOOP *EQ &TRYMAX) THEN(DO)                                         /*113734*/
                 GOTO ENDTRY2                                                             /*113734*/
             ENDDO                                                                        /*113734*/
             CHGVAR     VAR(&LOOP) VALUE(&LOOP + 1)                                       /*113734*/
 
/* */                                                                /*063524*/
/** Delay job for 30 seconds to allow PC access to file           */ /*063524*/
/* */                                                                /*063524*/
             DLYJOB     DLY(30)                                      /*063524*/
/* copy successful => TRAM.DAT exists => PC is busy so try again */
                GOTO TRY2
 
ENDTRY2:                                                                                  /*113734*/
/* After 5 loops check if TRAMHOST.DAT, TRAMSWFT.DAT and                                    113734*/
/* TRAMCPTY.DAT exist.  If they don't, it is safe to delete                                 113734*/
/* TRAM.DAT.  If they do, send message to QSYSOPR to see if TRAM                            113734*/
/* PC is in AUTO.  If not, delete TRAM.DAT but warn QSYSOPR that                            113734*/
/* TRAM was not closed properly.                                                            113734*/
             IF  (&LOOP *LT &TRYMAX) THEN(DO)                                             /*113734*/
                 GOTO COPY2                                                               /*113734*/
                 ENDDO                                                                    /*113734*/
             CHGVAR  &CHKMSGRPLY VALUE(' ')                                               /*113734*/
                                                                                          /*113734*/
CHECKDOC2:   CHGVAR  &TRAMHOSTF VALUE('Y')                                                /*113734*/
             CHGVAR  &TRAMSWFTF VALUE('Y')                                                /*113734*/
             CHGVAR  &TRAMCPTYF VALUE('Y')                                                /*113734*/
                                                                                          /*113734*/
             CHKDLO  DLO(TRAMHOST.DAT) FLR(&FLR)                                          /*113734*/
             MONMSG (CPF8A82) +
                    EXEC(CHGVAR &TRAMHOSTF VALUE('N'))                                    /*113734*/
                                                                                          /*113734*/
             CHKDLO  DLO(TRAMSWFT.DAT) FLR(&FLR)                                          /*113734*/
             MONMSG (CPF8A82) +
                    EXEC(CHGVAR &TRAMSWFTF VALUE('N'))                                    /*113734*/
                                                                                          /*113734*/
             CHKDLO  DLO(TRAMCPTY.DAT) FLR(&FLR)                                          /*113734*/
             MONMSG (CPF8A82) +
                    EXEC(CHGVAR &TRAMCPTYF VALUE('N'))                                    /*113734*/
                                                                                          /*113734*/
/* If the other documents do not exist then delete TRAM.DAT marker                        /*113734*/
             IF   ((&TRAMHOSTF *EQ 'N') *AND +
                   (&TRAMSWFTF *EQ 'N') *AND +
                   (&TRAMCPTYF *EQ 'N')) THEN(DO)                                         /*113734*/
                  GOTO DLTDOC2                                                            /*113734*/
                  ENDDO                                                                   /*113734*/
                                                                                          /*113734*/
/* If the 'Continue' reply was taken to the 'Check PC not in Auto'                        /*113734*/
/* message. (And there other documents still exist i.e PC not now                         /*113734*/
/* taken out of AUTO mode). Then delete TRAM.DAT marker                                   /*113734*/
             IF   (&CHKMSGRPLY *EQ 'C') THEN(DO)                                          /*113734*/
                  GOTO DLTDOC2                                                            /*113734*/
                  ENDDO                                                                   /*113734*/
                                                                                          /*113734*/
/* Send message and await for reply. When reply received the document                       113734*/
/* PC maybe not be using the folder any more. If it still is then                           113734*/
/* recheck which other Folders are present. If reply is not Continue                        113734*/
/* then go back to check if PC using FLR                                                    113734*/
             SNDUSRMSG  MSG('Please check that TRAM PC is not in +
                          AUTO mode.Enter ''C'' to continue if it +
                          is not') TOMSGQ(MOPERQ) +
                          MSGRPY(&MSGREPLY)                                               /*113734*/
             CPYFRMPCD  FROMFLR(&FLR) TOFILE(CFBUSYPD) +
                          FROMDOC(TRAM.DAT) MBROPT(*REPLACE) +
                          TRNFMT(*NOTEXT)                                                 /*113734*/
                 MONMSG  (CPF3137) EXEC(GOTO ERROR)                                       /*113734*/
                 MONMSG  (CPF8A82 IWS168B IWS1611) EXEC(GOTO COPY2)                       /*113734*/
                                                                                          /*113734*/
             IF   ((&MSGREPLY *EQ 'C') *OR +
                   (&MSGREPLY *EQ 'c')) THEN(DO)                                          /*113734*/
                   CHGVAR &CHKMSGRPLY VALUE('C')                                          /*113734*/
                   GOTO CHECKDOC2                                                         /*113734*/
                   ENDDO                                                                  /*113734*/
             ELSE (DO)                                                                    /*113734*/
                   CHGVAR &CHKMSGRPLY VALUE(&MSGREPLY)                                    /*113734*/
                   GOTO RETRY2                                                            /*113734*/
                   ENDDO                                                                  /*113734*/
                                                                                          /*113734*/
/* following line should not get executed but just a fail safe                              113734*/
/* the only way to get to DLTDOC is from the GOTOs above                                    113734*/
            GOTO   COPY2                                                                  /*113734*/
                                                                                          /*113734*/
DLTDOC2:                                                                                  /*113734*/
            DLTDLO  DLO(TRAM.DAT) FLR(&FLR)                                               /*113734*/
            MONMSG (CPF8A82 CPF8A16)  EXEC(GOTO COPY2)                                    /*113734*/
                                                                                          /*113734*/
/* If TRAM.DAT deleted here then send messages to MOPERQ for                                113734*/
/* diagnostics                                                                              113734*/
            SNDPGMMSG  MSG('TRAM PC was taken out of Auto mode +
                    incorrectly - please ask TRAM users to +
                    check their files are correct') +
                    TOMSGQ(MOPERQ)                                                        /*113734*/
            SNDPGMMSG  MSG('TRAM.DAT document still existed +
                     and was deleted in CFC0185')   +
                     TOMSGQ(MOPERQ)                                                       /*113734*/
            IF (&TRAMHOSTF *EQ 'Y') THEN(DO)                                              /*113734*/
                SNDPGMMSG  MSG('TRAMHOST.DAT document existed +
                     when Message was answered in CFC0185')   +
                     TOMSGQ(MOPERQ)                                                       /*113734*/
                ENDDO                                                                     /*113734*/
            IF (&TRAMSWFTF *EQ 'Y') THEN(DO)                                              /*113734*/
                SNDPGMMSG  MSG('TRAMSWFT.DAT document existed +
                     when Message was answered in CFC0185')   +
                     TOMSGQ(MOPERQ)                                                       /*113734*/
                ENDDO                                                                     /*113734*/
            IF (&TRAMCPTYF *EQ 'Y') THEN(DO)                                              /*113734*/
                SNDPGMMSG  MSG('TRAMCPTY.DAT document existed +
                     when Message was answered in CFC0185')   +
                     TOMSGQ(MOPERQ)                                                       /*113734*/
                ENDDO                                                                     /*113734*/
                                                                                          /*113734*/
/* allocate folder by creating MIDAS.DAT document */
COPY2:          CPYTOPCD   FROMFILE(*LIBL/CFBUSYPD) TOFLR(&FOLDER) +
                           TODOC(MIDAS.DAT) REPLACE(*YES) +
                           TRNFMT(*NOTEXT)
 
/* copy PC doc TRAMCPTY.DAT, if it exists, to work file             */
/* doesn't matter if document not found, CFWCLNPD will remain empty */
                CPYFRMPCD  FROMFLR(&FOLDER) TOFILE(QTEMP/CFWCLNPD) +
                           FROMDOC(TRAMCPTY.DAT) MBROPT(*REPLACE) +
                           TRNFMT(*TEXT)
                MONMSG     MSGID(CPF8A82 IWS1602 IWS168B IWS1611)
                DLTDLO     DLO(TRAMCPTY.DAT) FLR(&FOLDER)
                MONMSG     MSGID(CPF8A82 CPF8A16)
 
/* add client extract to work file CFWCLNPD */
                CPYF       FROMFILE(*LIBL/CFCLNTPD) +
                           TOFILE(QTEMP/CFWCLNPD) MBROPT(*ADD) +
                           CRTFILE(*NO)
 
/* copy work file back to PC doc TRAMCPTY.DAT, if TRAMCPTY.DAT does */
/* not exist, it will be created automatically                      */
                CPYTOPCD   FROMFILE(QTEMP/CFWCLNPD) TOFLR(&FOLDER) +
                           TODOC(TRAMCPTY.DAT) REPLACE(*YES) +
                           TRNFMT(*TEXT)
 
/* deallocate folder by removing MIDAS.DAT document */
                DLTDLO     DLO(MIDAS.DAT) FLR(&FOLDER)
             MONMSG     MSGID(CPF8A82 CPF8A16)                       /*062770*/
 
/* save this TRAM id and then process the next TRAM system */
                CHGVAR     VAR(&SAVIMID) VALUE(&IMID)
 
                GOTO       CMDLBL(NEXTTRAM)
 
/* update last client transfer date on CFSTAT with run date */
UPDATE:         RTVDTAARA  DTAARA(CFSTAT (60 5)) RTNVAR(&RUND)
                CHGDTAARA  DTAARA(CFSTAT (55 5)) VALUE(&RUND)
 
                ENDDO
 
             GOTO       CMDLBL(END)
ERROR:       SNDPGMMSG  MSG('Download Client Details to TRAM program +
                        ENDED ABNORMALLY') TOPGMQ(*EXT) +
                        TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
END:         ENDPGM
