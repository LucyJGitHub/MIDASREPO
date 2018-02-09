/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas RE T&N Accounts - ICI Component')               */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail T&N Accounts                                 */
/*                                                                   */
/*       REC4006 - ICI Component                                     */
/*                                                                   */
/*       (c) Finastra International Limited 2009                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CCB020             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*                      237781             Date 18Dec09              */
/*                      237976             Date 18Dec09              */
/*                      234686             Date 18Dec09              */
/*                      230517             Date 18Dec09              */
/*                      123570             Date 18Dec09              */
/*                      118466             Date 18Dec09              */
/*                      BUG27460           Date 18Dec09              */
/*                      CRE015 *CREATE     Date 18Dec09              */
/*-------------------------------------------------------------------*/
/*       MD046248 - Finastra Rebranding                              */
/*       CCB020 - COB Restructure - Secondary COB Infrastructure     */
/*       237781 - No interest capitalisation on some T&N accounts.   */
/*       237976 - Ensure next cap dates on ACCNTAB match REPRPNPD    */
/*       234686 - Error processing incorrect:                        */
/*                Should change job  switches whenever there is      */
/*                abnormal processing.                               */
/*                End journalling is unnecessary.                    */
/*       230517 - If Term & Notice record has reached 'Z' period     */
/*                or no longer exists, then drop notifications.      */
/*              - Incomplete 118466, put the library of the file     */
/*       123570 - Program ran for 40 hours at quarter end            */
/*                OPNQRYF was picked up the default records & assumed*/
/*                that the GL cap. records were for them. So GLPPOSPD*/
/*                received 1.4M records instead of 3000              */
/*       118466 - Various changes to solve problems with accrued int.*/
/*       BUG27460 - Applied client fix AS0001                        */
/*       AS0001 - Improve selection of cap postings                  */
/*       CRE015 - Retail Term and Notice Accounts                    */
/*********************************************************************/
 
             PGM        PARM(&CNAM &CSEQ)
 
             DCL        VAR(&DPLIB)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&TEXT)   TYPE(*CHAR) LEN(50)
             DCL        VAR(&MTEXT)  TYPE(*CHAR) LEN(50)
             DCL        VAR(&CNAM)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ)   TYPE(*DEC)  LEN(5 0)
             DCL        VAR(&MEM)    TYPE(*CHAR) LEN(50)
             DCL        VAR(&RESTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&BUSY)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&BACKUP) TYPE(*CHAR) LEN(1) VALUE(' ')
/**********  DCL        VAR(&MPHAS)  TYPE(*CHAR) LEN(1) VALUE(' ')                     */ /*CCB020*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2009')
 
/*********************************************************************/
/* INITIALISATION...                                                 */
/*********************************************************************/
 
/* Global Monitor Message */
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNORM))
             SNDPGMMSG  MSG('REC4006 - Term & Notice Input Cycle +
                          initiation') TOMSGQ(MRUNQ)
 
/* Global values */
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&DPLIB)
             CHGVAR     VAR(&DPLIB) VALUE(&DPLIB *TCAT 'DPLIB')
/**********  RTVDTAARA  DTAARA(MPHAS (1 1)) RTNVAR(&MPHAS)                             */ /*CCB020*/
             STRCMTCTL *CHG
             MONMSG CPF0000
 
/* Marker tect for re-run identification */
 
             RTVDTAARA  DTAARA(RUNDAT (1 7)) RTNVAR(&MTEXT)
             CHGVAR     VAR(&MTEXT) VALUE(%SST(&MTEXT 1 7) *TCAT +
                          'REC4006')
             CHGJOB     SWS(XXXXXX00)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(' ')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
 
/* If not called in input cycle...*/
 
/**********  IF         COND(&MPHAS *NE 'A') THEN(DO)                                  */ /*CCB020*/
             CHGVAR     VAR(&BUSY) VALUE('N')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &BUSY)
/**********  ENDDO                                                                     */ /*CCB020*/
 
/* Delete TMP files */
 
             DLTF       FILE(&DPLIB/RENFMVTMP)
             MONMSG CPF0000
             DLTF       FILE(&DPLIB/REPRPNTMP)
             MONMSG CPF0000
             DLTF       FILE(&DPLIB/RERTMUTMP)
             MONMSG CPF0000
             DLTF       FILE(&DPLIB/RERTMVTMP)
             MONMSG CPF0000
 
/* Create back-up copies of files */
 
             CPYF       FROMFILE(RENFMVPD) TOFILE(&DPLIB/RENFMVTMP) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             CPYF       FROMFILE(REPRPNPD) TOFILE(&DPLIB/REPRPNTMP) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             CPYF       FROMFILE(RERTMUPD) TOFILE(&DPLIB/RERTMUTMP) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             CPYF       FROMFILE(RERTMVPD) TOFILE(&DPLIB/RERTMVTMP) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             CHGVAR     VAR(&BACKUP) VALUE('Y')
 
/* ABORT IF QRY FILES FOUND */                                                            /*118466*/
 
             DLTF       FILE(&DPLIB/RENFMVQRY)                                            /*234686*/
             MONMSG     CPF0000                                                           /*234686*/
             CRTDUPOBJ  OBJ(RENFMVPD) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&DPLIB) NEWOBJ(RENFMVQRY) DATA(*NO)                       /*234686*/
 
             DLTF       FILE(&DPLIB/RENFMVQRY2)                                           /*234686*/
             MONMSG     CPF0000                                                           /*234686*/
             CRTDUPOBJ  OBJ(RENFMVPD) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&DPLIB) NEWOBJ(RENFMVQRY2) DATA(*NO)                      /*234686*/
 
             DLTF       FILE(&DPLIB/REPRPNQRY)                                            /*234686*/
             MONMSG     CPF0000                                                           /*234686*/
             CRTDUPOBJ  OBJ(REPRPNPD) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&DPLIB) NEWOBJ(REPRPNQRY) DATA(*NO)                       /*234686*/
 
/* Re-organization */
 
/* PERIODS AND PENALTIES TO BE RETAINED IF ... */                                         /*118466*/
/*    DFT COMBINATION                                                                     /*118466*/
/*    EXISTING ACCOUNT                                                                    /*118466*/
 
             OPNQRYF    FILE((REPRPNPD)) QRYSLT('E2BRCA=''   '' *or +
                          e2cnum=''      '' *or e2ccy=''   '' *or +
                          e2acod=0 *or e2acsq=0') IGNDECERR(*YES) +
                          CCSID(*HEX)                                                     /*234686*/
             CPYFRMQRYF FROMOPNID(REPRPNPD) TOFILE(&DPLIB/REPRPNQRY) +
                          MBROPT(*REPLACE) CRTFILE(*NO)                                   /*234686*/
             CLOF       OPNID(REPRPNPD)                                                   /*118466*/
             OPNQRYF    FILE((REPRPNPD) (ACCNTAB)) FORMAT(REPRPNQRY) +
                          JFLD((1/E2BRCA 2/BRCA) (1/E2CNUM 2/CNUM) +
                          (1/E2CCY 2/CCY) (1/E2ACOD 2/ACOD) +
                          (1/E2ACSQ 2/ACSQ)) JDFTVAL(*NO) +
                          IGNDECERR(*YES) CCSID(*HEX)                                     /*234686*/
             CPYFRMQRYF FROMOPNID(REPRPNPD) TOFILE(&DPLIB/REPRPNQRY) +
                          MBROPT(*ADD)                                                    /*118466*/
             CLOF       OPNID(REPRPNPD)                                                   /*118466*/
             CLRPFM     FILE(REPRPNPD)                                                    /*118466*/
             CPYF       FROMFILE(REPRPNQRY) TOFILE(REPRPNPD) +
                          MBROPT(*ADD)                                                    /*118466*/
             DLTF       FILE(REPRPNQRY)                                                   /*118466*/
 
/* RTM TO BE CLEARED DAILY */
 
             CLRPFM     FILE(RERTMVPD)
             CLRPFM     FILE(RERTMUPD)
 
/* NFM TO BE RETAINED WHERE AMT NE 0 (OR INTEREST) */
 
             OPNQRYF    FILE((RENFMVPD)) QRYSLT('E3CAVL *NE 0 *OR +
                          E3TRR1 *EQ ''N0000000''') IGNDECERR(*YES) +
                          CCSID(*HEX)                                                     /*234686*/
             CPYFRMQRYF FROMOPNID(RENFMVPD) TOFILE(&DPLIB/RENFMVQRY) +
                          MBROPT(*REPLACE) CRTFILE(*NO)                                   /*234686*/
             CLOF       OPNID(RENFMVPD)
             OPNQRYF    FILE((RENFMVQRY) (REPRPNPD)) FORMAT(RENFMVPD) +
                          QRYSLT('E2EVNT = ''A''')     +
                          JFLD((1/E3KEY1 2/E2KEY1)) +
                          JDFTVAL(*NO) +
                          IGNDECERR(*YES)  CCSID(*HEX)                                    /*234686*/
             CPYFRMQRYF FROMOPNID(RENFMVQRY) +
                          TOFILE(&DPLIB/RENFMVQRY2) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                                  /*230517*/
             CLOF       OPNID(RENFMVQRY)                                                  /*230517*/
 
             CLRPFM     FILE(RENFMVPD)
             CPYF       FROMFILE(&DPLIB/RENFMVQRY2) TOFILE(RENFMVPD) +
                          MBROPT(*ADD)                                                    /*230517*/
             DLTF       FILE(&DPLIB/RENFMVQRY)                                            /*230517*/
             DLTF       FILE(&DPLIB/RENFMVQRY2)                                           /*230517*/
 
/**********************************************************************/
/* PREPARE FOR NEW RUN DATE */
/**********************************************************************/
 
/* SKIP INTEREST CAPTURE, IF ALREADY DONE TODAY */
 
             RTVMBRD    FILE(GLPPOSPD) TEXT(&TEXT)
             IF (&TEXT *NE &MTEXT) THEN(DO)
 
/* CAPTURE PREVIOUS COB'S INTEREST POSTINGS */
 
             CLRPFM     FILE(GLPPOSPD)
 
             OPNQRYF    FILE((REPRPNPD) (GEICPD)) FORMAT(GLPPOSPD) +
                          QRYSLT('(1/E2EVNT *EQ ''A'') *AND +
                          (1/E2ITEM *EQ 1) *AND (1/E2IRLI *EQ +
                          ''P'') *AND (2/TRAT *EQ 91060) *AND +
                          (1/E2BRCA *NE ''   '') *AND (1/E2CNUM *NE +
                          ''      '') *AND (1/E2CCY *NE ''   '') +
                          *AND (1/E2ACOD *NE 0) *AND (1/E2ACSQ *NE +
                          0)') JFLD((1/E2KEY1 *MAPFLD/ACNOA *EQ)) +
                          MAPFLD((ACNOA '2/ACNO' *CHAR 10) (IPDN +
                          ''' ''') (ZZ019 ''' ''') (TLIN ''' ''') +
                          (TRCCY ''' ''') (STYP ''' ''') (CQRI ''' +
                          ''') (PBTT ''' ''') (ORBR ''' ''') (ORAMT +
                          0)) IGNDECERR(*YES) OPNID(POSTINGS)                             /*123570*/
 
             CPYFRMQRYF FROMOPNID(POSTINGS) TOFILE(GLPPOSPD) +
                          MBROPT(*ADD)
             CLOF       OPNID(POSTINGS)
 
             OPNQRYF    FILE((REPRPNPD) (GEIC2PD)) FORMAT(GLPPOSPD) +
                          QRYSLT('(1/E2EVNT *EQ ''A'') *AND +
                          (1/E2ITEM *EQ 1) *AND (1/E2IRLI *EQ +
                          ''P'') *AND (2/TRAT *EQ 91060) *AND +
                          (1/E2BRCA *NE ''   '') *AND (1/E2CNUM *NE +
                          ''      '') *AND (1/E2CCY *NE ''   '') +
                          *AND (1/E2ACOD *NE 0) *AND (1/E2ACSQ *NE +
                          0)') JFLD((1/E2KEY1 *MAPFLD/ACNOA *EQ)) +
                          MAPFLD((ACNOA '2/ACNO' *CHAR 10) (IPDN +
                          ''' ''') (ZZ019 ''' ''') (TLIN ''' ''') +
                          (TRCCY ''' ''') (STYP ''' ''') (CQRI ''' +
                          ''') (PBTT ''' ''') (ORBR ''' ''') (ORAMT +
                          0)) IGNDECERR(*YES) OPNID(POSTINGS)                             /*123570*/
 
             CPYFRMQRYF FROMOPNID(POSTINGS) TOFILE(GLPPOSPD) +
                          MBROPT(*ADD)                                                    /*118466*/
             CLOF       OPNID(POSTINGS)                                                   /*118466*/
             CHGPFM     FILE(GLPPOSPD) MBR(*FIRST) TEXT(&MTEXT)                           /*118466*/
             ENDDO
 
/* CALL HLL PROGRAM TO PROCESS INTEREST POSTINGS TO BE NOTIFIED */
/* ... PERIODS TO BE ADVANCED */
/* ... HISTORY BAL TO BAL NOTIFS */
/* ... RETENTION OF NOTIFS */
 
             OVRDBF     FILE(REPRPNPD) SHARE(*NO)
             OVRDBF     FILE(RENFMVPD) SHARE(*NO)
             OVRDBF     FILE(ACCNT) SHARE(*NO)
             CALL       PGM(RE4006)
             MONMSG CPF0000 EXEC(CHGJOB SWS(XXXXXX11))
             IF (*NOT %SWITCH(XXXXXX00)) THEN(GOTO ABNORM)                                /*237976*/
 
/* Call program to ensure that next capitalisation dates are synchronized */              /*237976*/
 
             CALL       PGM(RE4019)                                                       /*237976*/
 
             MONMSG CPF0000 EXEC(CHGJOB SWS(XXXXXX11))                                    /*237976*/
             DLTOVR     FILE(RENFMVPD)
             DLTOVR     FILE(REPRPNPD)
             DLTOVR     FILE(ACCNT)
             IF (*NOT %SWITCH(XXXXXX00)) THEN(GOTO ABNORM)
 
/**********************************************************************/
/* EXIT... */
/**********************************************************************/
 
/* COMMIT CHANGES  */                                                                     /*237781*/
 
             COMMIT                                                                       /*237781*/
 
/* CLEAR FILES ON NORMAL COMPLETION */
 
             CLRPFM     FILE(GLPPOSPD)
 
/* Reset restart flag and clear SAVF if run succesful */
 
             IF COND(%SWITCH(XXXXXX00)) THEN(DO)
                 ALCOBJ     OBJ((RESTAT *DTAARA *EXCLRD))
                 RTVDTAARA  DTAARA(RESTAT) RTNVAR(&RESTAT)
                 IF         COND(%SWITCH(XX1XXXXX)) THEN(CHGVAR +
                            VAR(%SST(&RESTAT 23 1)) VALUE('Y'))
/**********  IF         COND(&MPHAS *NE 'A') THEN(DO)                                  */ /*CCB020*/
                 CHGVAR     VAR(&BUSY) VALUE('O')
                 CALL       PGM(CB0150) PARM(&CNAM &CSEQ &BUSY)
/**********      ENDDO                                                                 */ /*CCB020*/
                 CHGDTAARA  DTAARA(RESTAT) VALUE(&RESTAT)
                 DLCOBJ     OBJ((RESTAT *DTAARA *EXCLRD))
                 GOTO ENDPGM
              ENDDO
 
             IF (*NOT %SWITCH(XXXXXX00)) THEN(GOTO ABNORM)
ABNORM:
 
/* Database Error has occurred */
 
             CHGJOB     SWS(XXXXXX11)                                                     /*234686*/
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                        TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
/**********  IF         COND(&MPHAS *NE 'A') THEN(DO)                                  */ /*CCB020*/
             CHGVAR     VAR(&BUSY) VALUE('N')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &BUSY)
/**********  ENDDO                                                                     */ /*CCB020*/
             DMPCLPGM
             SNDPGMMSG  MSG('REC4006 ended abnormally') +
                          TOMSGQ(MOPERQ)
 
/* If back up was successful then */
/* Copy back back-up copies of files */
 
             IF         COND(&BACKUP = 'Y') THEN(DO)
             CPYF       FROMFILE(RENFMVTMP) TOFILE(RENFMVPD) +
                          MBROPT(*REPLACE)
             MONMSG CPF0000
             CPYF       FROMFILE(REPRPNTMP) TOFILE(REPRPNPD) +
                          MBROPT(*REPLACE)
             MONMSG CPF0000
             CPYF       FROMFILE(RERTMUTMP) TOFILE(RERTMUPD) +
                          MBROPT(*REPLACE)
             MONMSG CPF0000
             CPYF       FROMFILE(RERTMVTMP) TOFILE(RERTMVPD) +
                          MBROPT(*REPLACE)
             MONMSG CPF0000
             ENDDO
             ROLLBACK                                                                     /*237781*/
 
ENDPGM:
             ENDCMTCTL                                                                    /*237781*/
 
             ENDPGM
