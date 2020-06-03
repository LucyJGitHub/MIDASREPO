/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas MC Balance generated postings')                 */
/*********************************************************************/
/*                                                                   */
/*       Midas - Management Accounts Module                          */
/*                                                                   */
/*       MCC0310 - Balance Generated Postings                        */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD049512           Date 10Aug18              */
/*       Prev Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      244853             Date 08Mar07              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      BUG12454           Date 06Nov06              */
/*                      CGL029             Date 01Sep03              */
/* Midas Release 4.01 -----------------------------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.04 ---------------------------------------------------*/
/*                      157088             Date 13Nov00              */
/*                      185146             Date 09Nov00              */
/*                      135786             Date 02Nov00              */
/* Midas DBA 3.02 ---------------------------------------------------*/
/*                      162421             Date 05Oct99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      136596             Date 13May98              */
/*                      CMC001 *CREATE     Date 18MAR96              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD049512 - All real time postings are reprocessed everytime */
/*                  GLC450 runs causing imbalance in GLHIBL. Ensure  */
/*                  RTPJ are only processed once.                    */
/*       MD046248 - Finastra Rebranding                              */
/*       244853 - FCIE transfer incorrect following non-working day. */
/*                Applied fix 205165.                                */
/*       BUG12454 - Changed OPNQRYF statements for alpha customer    */
/*                  number                                           */
/*       CGL029 - Increase Account Code to 10 digits                 */
/*       157088 - Entry with posting time < last posting time in the */
/*                control group file should be excluded as they have */
/*                been posted already.                               */
/*              - DIAG                                               */
/*                ACJNDn   >> OPNQRY >> MCPOSTPD                     */
/*                MCPOSTPD >> MC0310 >> MCFMVMPD                     */
/*                MCFMVMPD >> OPNQRY >> MCMOVEPD                     */
/*                MCMOVEPD >> MC0315 >> MCPCBLPD                     */
/*       185146 - Collected fix 136596 incorped some changes in this */
/*                program which apparently has nothing to with the   */
/*                error raised orginally in 136596.  In addition     */
/*                the desciption for 136596 is also unclear on why   */
/*                the changes has been made.  This may later cause   */
/*                0.01 different in late componet due to such change */
/*                Remove 136596 in this program only. *              */
/*                * - Core Mgt Note - See 135786 below.              */
/*       135786 - Admin only - Fix 136596 below should have been     */
/*                incorporated under the GEMS number 135786.         */
/*       162421 - Select entries from GEDLPD with RECI NE '*'        */
/*                (Fix 137957)                                       */
/*       136596 - GLHIBLPD. CR fields contain +figure and DR fields */
/*                 contain -figure.                                  */
/*       CMC001 - Created for Management Accounts                    */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&FILE)
/**/
/**  Copyright statement definition  */
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
/**  Declare variables */
/**/
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&GROUPCODE) TYPE(*CHAR) LEN(2) /*Group +
                          Code*/
             DCL        VAR(&PERIODSET) TYPE(*CHAR) LEN(1) /*Period +
                          Set*/
             DCL        VAR(&POSTINGBAS) TYPE(*CHAR) LEN(1) +
                          /*Posting Basis*/
             DCL        VAR(&STARTDATE) TYPE(*CHAR) LEN(5) /*Start +
                          Date*/
             DCL        VAR(&SECTIONS) TYPE(*CHAR) LEN(8) /*Sections*/
             DCL        VAR(&ANALYSIS) TYPE(*CHAR) LEN(10) /*Analysis*/
             DCL        VAR(&STARTTIME) TYPE(*CHAR) LEN(6) /*Start +
                          Time*/
             DCL        VAR(&RETURNCODE) TYPE(*CHAR) LEN(1) /*Return +
                          Code*/
             DCL        VAR(&I) TYPE(*DEC) LEN(3 0) VALUE(1) /* +
                          Index for key sort */
             DCL        VAR(&J) TYPE(*DEC) LEN(3 0) /* Index for key +
                          sort */
             DCL        VAR(&I2) TYPE(*DEC) LEN(3 0) /* Index for +
                          key sort */
             DCL        VAR(&J2) TYPE(*DEC) LEN(3 0) /* Index for +
                          key sort */
             DCL        VAR(&KU) TYPE(*CHAR) LEN(40) VALUE('    CCY +
                          BRCACNUMACSQ    BOKCOTTPOTST    ') /* Key +
                          array - not sorted */
             DCL        VAR(&KT) TYPE(*CHAR) LEN(40) VALUE('ACODCCY +
                          BRCACNUMACSQPRFCBOKCOTTPOTSTASOC') /* Key +
                          array - not sorted */
             DCL        VAR(&KS) TYPE(*CHAR) LEN(40) /* Key array - +
                          sorted */
             DCL        VAR(&KEYFLD) TYPE(*CHAR) LEN(100) /* Key +
                          list for OPNQRYF */
             DCL        VAR(&OPNQRYF) TYPE(*CHAR) LEN(2000) /* CMD +
                          String for QCMDEXC */
             DCL        VAR(&DSFDY) TYPE(*CHAR) LEN(200) /*        +
                          Return string */
/* Start Date and Time */                                             /*157088*/
             DCL        VAR(&SDYTM) TYPE(*DEC) LEN(11 0) VALUE(0)     /*157088*/
             DCL        VAR(&STIME) TYPE(*DEC) LEN(6 0) VALUE(0)      /*157088*/
             DCL        VAR(&SDYTA) TYPE(*CHAR) LEN(11)               /*157088*/
/*/COPY WNCPYSRC,MCH00001                                            */
/**/
/**  Global error message */
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ERROR))
/**/
/**  Create LDA if it does not already exist */
/**/
             CHKOBJ     OBJ(LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                          DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(' ') TEXT('MIDAS SD AS400 LOCAL +
                          DATA AREA EQUIVALENT'))
/**/
/**  Send Message to MRUNQ */
/**/
             SNDPGMMSG  MSG('MCC0310 - Balance Generated Postings') +
                          TOMSGQ(MRUNQ)
/**/
/**  Set Job Switch */
/**/
             CHGJOB     SWS(00000000)
/**/
/**  Access PCA ICD for Primary Control Group */
/**/
             CALL       PGM(AOPCACR0) PARM(&RETURNCODE '*FIRST' &DSFDY)
             CHGVAR     VAR(&GROUPCODE) VALUE(%SST(&DSFDY 15 2))
/**/
/**  Call the Update Control Group program                             */
/**  Note that only &GROUPCODE is passed in as non blank, all the      */
/**  rest are filled by MC0264                                         */
/**/
/*/COPY WNCPYSRC,MCH00002                                            */
             CALL       PGM(MC0264) PARM(&GROUPCODE &PERIODSET +
                          &POSTINGBAS &STARTDATE &SECTIONS +
                          &ANALYSIS &STARTTIME)
/**/
/**  Check no database error  */
/**/
             IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO +
                          CMDLBL(ERROR))
             IF         COND(%SWITCH(XXXXXXX1)) THEN(GOTO +
                          CMDLBL(ERROR))
/**/                                                                  /*157088*/
/* Start Date and Time = Startdate *CAT Starttime */                  /*157088*/
/**/                                                                  /*157088*/
             CHGVAR     VAR(&SDYTM) VALUE(&STARTDATE)                 /*157088*/
             CHGVAR     VAR(&STIME) VALUE(&STARTTIME)                 /*157088*/
             CHGVAR     VAR(&SDYTM) VALUE(&SDYTM * 1000000 )          /*157088*/
             CHGVAR     VAR(&SDYTM) VALUE(&SDYTM + &STIME)            /*157088*/
             CHGVAR     VAR(&SDYTA) VALUE(&SDYTM)                     /*157088*/
/**/
/**  Sort keys into order specified in &ANALYSIS  */
/**/
 LOOP1:      IF         COND(&I *GT 10) THEN(GOTO CMDLBL(EXIT1))
             IF         COND(%SST(&ANALYSIS &I 1) *NE ' ') THEN(DO)
                CHGVAR     VAR(&J) VALUE(%SST(&ANALYSIS &I 1))
                CHGVAR     VAR(&I2) VALUE(1 + ((&I - 1) * 4))
                CHGVAR     VAR(&J2) VALUE(1 + (&J * 4))
                CHGVAR     VAR(%SST(&KS &J2 4)) VALUE(%SST(&KU &I2 4))
             ENDDO
             CHGVAR     VAR(&I) VALUE(&I + 1)
             GOTO       CMDLBL(LOOP1)
/**/
/**  Set up keylist parameter for OPNQRYF  */
/**/
 EXIT1:      CHGVAR     VAR(&I) VALUE(1)
             CHGVAR     VAR(&KEYFLD) VALUE('(ACOD) (PRFC) (ASOC)')
 LOOP2:      IF         COND(&I *GT 40) THEN(GOTO CMDLBL(EXIT2))
             IF         COND(%SST(&KS &I 4) *NE '    ') THEN(CHGVAR +
                          VAR(&KEYFLD) VALUE(&KEYFLD *BCAT '(' +
                          *TCAT %SST(&KS &I 4) *TCAT ')'))
             CHGVAR     VAR(&I) VALUE(&I + 4)
             GOTO       CMDLBL(LOOP2)
/**/
 EXIT2:      CLOF       OPNID(&FILE)
             MONMSG     MSGID(CPF4520)
/**/
/**  Set up Input File */
/**/
/**  Set up OPNQRYF */
/**/
             CHGVAR     VAR(&OPNQRYF) VALUE('OPNQRYF FILE((' *TCAT +
                          &FILE *TCAT ')) FORMAT(MCPOSTPD)')
/* Start of 162421*/
/**  Fix to remove unpostable entries (RECI = *) from QRYF */         /*162421*/
/**/                                                                  /*162421*/
/************CHGVAR     VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT 'QRYSLT(' +
                   *CAT '''RECI *EQ ''''P''''' *CAT ''')') /*162421*/ /*157088*/
/* End of 162421*/
/* Start of 244853*/
/****Exclude*all*records*with*posting*time*<*start*time****************/                  /*244853*/
/**  Exclude all records from ACJND1 with posting date and time */                        /*244853*/
/**  less than or equal to the last posting date and time stored */                       /*244853*/
/**  in PF/GLHBCGPD. */                                                                   /*244853*/
/**/                                                                                      /*244853*/
/**********  IF         COND(&FILE *EQ 'ACJND1') THEN(DO)              */        /*244853 MD049512*/
/**********  CHGVAR     VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT 'QRYSLT(' + */               /*MD049512*/
/**********               *CAT '''RECI *EQ  "P"')                      */        /*157088 MD049512*/
/**********  CHGVAR     VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT '*AND WTIME *GT' +  */       /*MD049512*/
/**********               *BCAT &SDYTA *CAT ''')')                     */        /*157088 MD049512*/
/**********  ENDDO                                                     */        /*244853 MD049512*/
/**********  ELSE       CMD(CHGVAR VAR(&OPNQRYF) VALUE(&OPNQRYF +      */               /*MD049512*/
/**********               *BCAT 'QRYSLT(' *CAT '''RECI *EQ  +          */               /*MD049512*/
/**********               ''''P''''' *CAT ''')'))                      */        /*244853 MD049512*/
             CHGVAR     VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT 'QRYSLT(' +
                          *CAT '''RECI *EQ  ''''P''''' *CAT ''')')                      /*MD049512*/
/* End of 244853*/
/**/
/**  Set up sort fields */
/**/
             CHGVAR     VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT +
                          'KEYFLD((ACOD) (PRFC) (ASOC))')
/**/
/*/COPY WNCPYSRC,MCC0310001                                          */
             CHGVAR     VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT 'GRPFLD(' +
                          *TCAT &KEYFLD *BCAT '(EVDT) (VOIN) (DRCR) +
                          (GETP) (ACSC) (ATYP)) MAPFLD((WAMT ''PSTA +
                          - (PSTA * 2 * DRCR)'') (WTIME ''(PSTD * +
                          1000000 + PTIM)'') (ACODQQ 0) (EVDT')                           /*CGL029*/
/**********               1000000 + PTIM)'') (EVDT')                 */                   /*CGL029*/
/**/
             IF         COND(&POSTINGBAS *EQ 'P') THEN(CHGVAR +
                          VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT 'PSTD)'))
             ELSE       CMD(CHGVAR VAR(&OPNQRYF) VALUE(&OPNQRYF +
                          *BCAT 'VALD)'))
/**/
             IF         COND(%SST(&ANALYSIS 2 1) *EQ ' ') +
                          THEN(CHGVAR VAR(&OPNQRYF) VALUE(&OPNQRYF +
                          *BCAT '(CCY ''''''   '''''')'))
             IF         COND(%SST(&ANALYSIS 3 1) *EQ ' ') +
                          THEN(CHGVAR VAR(&OPNQRYF) VALUE(&OPNQRYF +
                          *BCAT '(BRCA ''''''   '''''')'))
/**********  IF         COND(%SST(&ANALYSIS 4 1) *EQ ' ') +                             /*BUG12454*/
/**********               THEN(CHGVAR VAR(&OPNQRYF) VALUE(&OPNQRYF +                    /*BUG12454*/
/**********               *BCAT '(CNUM 0)')) */                                         /*BUG12454*/
             IF         COND(%SST(&ANALYSIS 4 1) *EQ ' ') +
                          THEN(CHGVAR VAR(&OPNQRYF) VALUE(&OPNQRYF +
                          *BCAT '(CNUM ''''''      '''''')'))                           /*BUG12454*/
             IF         COND(%SST(&ANALYSIS 5 1) *EQ ' ') +
                          THEN(CHGVAR VAR(&OPNQRYF) VALUE(&OPNQRYF +
                          *BCAT '(ACSQ 0)'))
             IF         COND(%SST(&ANALYSIS 6 1) *EQ ' ') +
                          THEN(CHGVAR VAR(&OPNQRYF) VALUE(&OPNQRYF +
                          *BCAT '(PRFC ''''''  '''''')'))
             IF         COND(%SST(&ANALYSIS 7 1) *EQ ' ') +
                          THEN(CHGVAR VAR(&OPNQRYF) VALUE(&OPNQRYF +
                          *BCAT '(BOKC ''''''  '''''')'))
             IF         COND(%SST(&ANALYSIS 8 1) *EQ ' ') +
                          THEN(CHGVAR VAR(&OPNQRYF) VALUE(&OPNQRYF +
                          *BCAT '(OTTP ''''''           '''''')'))
             IF         COND(%SST(&ANALYSIS 9 1) *EQ ' ') +
                          THEN(CHGVAR VAR(&OPNQRYF) VALUE(&OPNQRYF +
                          *BCAT '(OTST ''''''           '''''')'))
/**********  IF         COND(%SST(&ANALYSIS 10 1) *EQ ' ') +                            /*BUG12454*/
/**********               THEN(CHGVAR VAR(&OPNQRYF) VALUE(&OPNQRYF +                    /*BUG12454*/
/**********               *BCAT '(ASOC 0)')) */                                         /*BUG12454*/
             IF         COND(%SST(&ANALYSIS 10 1) *EQ ' ') +
                          THEN(CHGVAR VAR(&OPNQRYF) VALUE(&OPNQRYF +
                          *BCAT '(ASOC ''''''      '''''')'))                           /*BUG12454*/
/**/
             CHGVAR     VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT '(PDTM +
                          ''%MAX(WTIME)'') (CPNB 0) (PAMT +
                          ''%SUM(WAMT)'') (PNAR '''''' '''''')) +
                          OPTALLAP(*YES) +
                          IGNDECERR(*YES)')
/**/
/**  Clear output files */
/**/
             CLRPFM     FILE(MCFMVMPD)
             CLRPFM     FILE(MCMOVEPD)
             CLRPFM     FILE(MCPCBLPD)
             CLOF       OPNID(&FILE)
             MONMSG     MSGID(CPF4520)
/**/
/**  Override Files */
/**/
             OVRDBF     FILE(MCPOSTPD) SHARE(*YES) +
                          SEQONLY(*YES 352)
             OVRDBF     FILE(MCFMVMPD) SEQONLY(*YES 352)
/**/
/**  Run OPNQRYF to Sort file */
/**/
             CALL       PGM(QCMDEXC) PARM(&OPNQRYF 2000)
             CPYFRMQRYF FROMOPNID(&FILE) TOFILE(MCPOSTPD) +
                          MBROPT(*REPLACE) FMTOPT(*MAP *DROP)
/**/
/**  Call Postings filter program  */
/**/
             CALL       PGM(MC0310)
             DLTOVR     FILE(MCPOSTPD)
/**/
/**  Check for database error  */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(ERROR)
             ENDDO
/**/
/**  Summarise the filtered postings */
/**/
             CHGVAR     VAR(&I) VALUE(1)
 LOOP3:      IF         COND(&I *GT 10) THEN(GOTO CMDLBL(EXIT3))
             IF         COND(%SST(&ANALYSIS &I 1) *NE ' ') THEN(DO)
                CHGVAR     VAR(&J) VALUE(%SST(&ANALYSIS &I 1))
                CHGVAR     VAR(&I2) VALUE(1 + ((&I - 1) * 4))
                CHGVAR     VAR(&J2) VALUE(1 + (&J * 4))
                CHGVAR     VAR(%SST(&KS &J2 4)) VALUE(%SST(&KT &I2 4))
             ENDDO
             CHGVAR     VAR(&I) VALUE(&I + 1)
             GOTO       CMDLBL(LOOP3)
/**/
/**  Set up keylist parameter for OPNQRYF */
/**/
 EXIT3:      CHGVAR     VAR(&I) VALUE(1)
             CHGVAR     VAR(&KEYFLD) VALUE(' ')
 LOOP4:      IF         COND(&I *GT 40) THEN(GOTO CMDLBL(EXIT4))
             IF         COND(%SST(&KS &I 4) *NE '    ') THEN(CHGVAR +
                          VAR(&KEYFLD) VALUE(&KEYFLD *BCAT '(' +
                          *TCAT %SST(&KS &I 4) *TCAT ')'))
             CHGVAR     VAR(&I) VALUE(&I + 4)
             GOTO       CMDLBL(LOOP4)
/**/
 EXIT4:      CLOF       OPNID(MCFMVMPD)
             MONMSG     MSGID(CPF4520)
/**/
             CHGVAR     VAR(&OPNQRYF) VALUE('OPNQRYF +
                          FILE((MCFMVMPD))')
/**/
/*********** CHGVAR     VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT 'GRPFLD(' +*136596*/
/***********              *TCAT &KEYFLD *BCAT '(EVDT) (VOIN) +        *136596*/
/***********              (GETP) (ACSC) (ATYP)) MAPFLD(')             *136596*/
/*********** CHGVAR     VAR(&OPNQRYF) VALUE(&OPNQRYF +
                          *BCAT 'MAPFLD(')                    **136596 185146*/
             CHGVAR     VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT 'GRPFLD(' +
                          *TCAT &KEYFLD *BCAT '(EVDT) (VOIN) +
                          (GETP) (ACSC) (ATYP)) MAPFLD(')            /*185146*/
/**/
             IF         COND(%SST(&ANALYSIS 2 1) *EQ ' ') +
                          THEN(CHGVAR VAR(&OPNQRYF) VALUE(&OPNQRYF +
                          *BCAT '(CCY ''''''   '''''')'))
             IF         COND(%SST(&ANALYSIS 3 1) *EQ ' ') +
                          THEN(CHGVAR VAR(&OPNQRYF) VALUE(&OPNQRYF +
                          *BCAT '(BRCA ''''''   '''''')'))
/**********  IF         COND(%SST(&ANALYSIS 4 1) *EQ ' ') +                             /*BUG12454*/
/**********               THEN(CHGVAR VAR(&OPNQRYF) VALUE(&OPNQRYF +                    /*BUG12454*/
/**********               *BCAT '(CNUM 0)')) */                                         /*BUG12454*/
             IF         COND(%SST(&ANALYSIS 4 1) *EQ ' ') +
                          THEN(CHGVAR VAR(&OPNQRYF) VALUE(&OPNQRYF +
                          *BCAT '(CNUM ''''''      '''''')'))                           /*BUG12454*/
             IF         COND(%SST(&ANALYSIS 5 1) *EQ ' ') +
                          THEN(CHGVAR VAR(&OPNQRYF) VALUE(&OPNQRYF +
                          *BCAT '(ACSQ 0)'))
             IF         COND(%SST(&ANALYSIS 6 1) *EQ ' ') +
                          THEN(CHGVAR VAR(&OPNQRYF) VALUE(&OPNQRYF +
                          *BCAT '(PRFC ''''''  '''''')'))
             IF         COND(%SST(&ANALYSIS 7 1) *EQ ' ') +
                          THEN(CHGVAR VAR(&OPNQRYF) VALUE(&OPNQRYF +
                          *BCAT '(BOKC ''''''  '''''')'))
             IF         COND(%SST(&ANALYSIS 8 1) *EQ ' ') +
                          THEN(CHGVAR VAR(&OPNQRYF) VALUE(&OPNQRYF +
                          *BCAT '(OTTP ''''''  '''''')'))
             IF         COND(%SST(&ANALYSIS 9 1) *EQ ' ') +
                          THEN(CHGVAR VAR(&OPNQRYF) VALUE(&OPNQRYF +
                          *BCAT '(OTST '''''' '''''')'))
/**********  IF         COND(%SST(&ANALYSIS 10 1) *EQ ' ') +                            /*BUG12454*/
/**********               THEN(CHGVAR VAR(&OPNQRYF) VALUE(&OPNQRYF +                    /*BUG12454*/
/**********               *BCAT '(ASOC 0)')) */                                         /*BUG12454*/
             IF         COND(%SST(&ANALYSIS 10 1) *EQ ' ') +
                          THEN(CHGVAR VAR(&OPNQRYF) VALUE(&OPNQRYF +
                          *BCAT '(ASOC ''''''      '''''')'))                           /*BUG12454*/
/**/
/*********** CHGVAR     VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT '(PDTM +   *136596*/
/***********              ''%MAX(1/PDTM)'') (CPNB 0) (PAMT +          *136596*/
/***********              ''%SUM(1/PAMT)'') (PNAR '''''' '''''')) +   *136596*/
/***********              OPTALLAP(*YES)')                            *136596*/
/*********** CHGVAR     VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT '(CPNB +
                   0) (PNAR '''''' '''''')) OPTALLAP(*YES)')  /*136596 185146*/
/**********  CHGVAR     VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT '(PDTM +  */                   /*CGL029*/
/**********               ''%MAX(1/PDTM)'') (CPNB 0) (PAMT +         */                   /*CGL029*/
/**********               ''%SUM(1/PAMT)'') (PNAR '''''' '''''')) +  */                   /*CGL029*/
/**********               OPTALLAP(*YES)')                           */        /*185146*/ /*CGL029*/
             CHGVAR     VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT '(PDTM +
                          ''%MAX(1/PDTM)'') (CPNB 0) (PAMT +
                          ''%SUM(1/PAMT)'') (PNAR '''''' '''''') +
                          (ACODQQ 0)) OPTALLAP(*YES)')                                    /*CGL029*/
/**/
/**  Run OPNQRYF to SUMMARISE Midas Generated postings again */
/**/
             RCLRSC
             CALL       PGM(QCMDEXC) PARM(&OPNQRYF 2000)
/**/
             CPYFRMQRYF FROMOPNID(MCFMVMPD) TOFILE(MCMOVEPD) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)
/**/
/**  Call balance Generated postings  */
/**/
             RCLRSC
/*/COPY WNCPYSRC,MCH00003                                            */
             OVRDBF     FILE(MCPCBLPD) SEQONLY(*YES 352)
             CALL       PGM(MC0315)
/**/
/**  Check for database error  */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(ERROR)
             ENDDO
/**/
/**  Check for File Control Error */
/**/
             ELSE       CMD(IF COND(%SWITCH(XXXXXXX1)) THEN(DO))
                SNDPGMMSG  MSG('MC0310 - FILE CONTROLS OUT OF BALANCE') +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             ENDDO
/**/
             GOTO       CMDLBL(ENDPGM)
/**/
 ERROR:      CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSG('Balance Generated Postings - +
                          ENDED ABNORMALLY') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM