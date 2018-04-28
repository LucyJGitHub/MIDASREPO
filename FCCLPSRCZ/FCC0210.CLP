/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FC Periodic requests maintenance')              */
    /*****************************************************************/
    /*                                                               */
    /*  Midas - Report Control Facility Module               */
    /*                                                               */
    /*  FCC0210 - REQUEST A PERIODIC REPORT                          */
    /*                                                               */
/*       (c) Misys International Banking Systems Ltd. 2001           */
    /*                                                               */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
    /*       LAST AMEND NO. 096786           DATE 27MAR96            */
    /*       PREV AMEND NO. 092725           DATE 13OCT95            */
    /*                      S01486           DATE 07JUN94            */
    /*                      076789           DATE 03OCT94            */
    /*                      E46848             DATE 02APR93          */
    /*                      049424             DATE 11JAN93          */
    /*                      044847             DATE 23SEP92          */
    /*                      E38898           DATE 27APR92            */
    /*                      LN1279           DATE 18FEB91            */
    /*                      LN1165           DATE 18FEB91            */
    /*                      LN0448           DATE 28JUN90            */
    /*                      LN0425           DATE 25JUN90            */
    /*                      LN0302           DATE 30MAY90            */
    /*                                                               */
    /*****************************************************************/
    /*                                                               */
    /*      096786 - Blank out parameters if F12 taken to ensure     */
    /*               subsequent requests do not collect extraneous   */
    /*               parameters.                                     */
    /*      092725 - The program requires a record in SDPORTPD       */
    /*               even if  Portfolio Management is switched off   */
    /*               So check for Portfolio Management being switched*/
    /*               on before accessing SDPORTPD.                   */
    /*      S01486 - Private Banking Upgrade to Rel 10.              */
    /*               Introduce the new fields of Account Officer     */
    /*               and Department from MUSERDD to the selection    */
    /*               criteria for the OPNQRYF command.               */
    /*      076789 - Overrides moved to MLC0000                      */
    /*       E46848 - If single branch default level to blanks       */
    /*      049424 - IBM HAVE RENAMED THE OFFICE FILES AGAIN AT      */
    /*               V2R2. THE PROGRAM HAS BEEN AMENDED TO CALL A    */
    /*               NEW ACCESS OBJECT AOIBMDR0 WHICH RETURNS THE    */
    /*               OBJECT NAME AT THE MACHINE'S PRESENT IBM        */
    /*               RELEASE LEVEL FOR OVERRIDE PURPOSES.            */
    /*      044847 - OVERRIDE FILES AS THEY HAVEN'T THE SAME NAME ON */
    /*               DIFFERENT VERSIONS OF QUSRSYS.                  */
    /*      E38898 - IF THERE IS A PROPMT FOR A REPORT, WHEN F12 IS  */
    /*               TAKEN FROM REPORT INSTRUCTIONS SCREEN, GO BACK  */
    /*               TO THE PROMPT SCREEN. IF THERE IS NO PROMPT FOR */
    /*               FOR THIS REPORT, WHEN F12 IS TAKEN, GO BACK TO  */
    /*               MAIN CONTROLLING PROGRAM.                       */
    /*      LN1279 - RETURN TO FC0210 FROM FC0215 IF F12 IS TAKEN.   */
    /*      LN1165 - ADD DIFFERENT SELECT PARAMETERS FOR A           */
    /*               SINGLE BRANCH SYSTEM                            */
    /*      LN0448 - IF AMEND OR ENQUIRY,ORIGINAL PARAMETERS PASSED  */
    /*               TO PROMPT PROGRAM FROM FCPARPPD.                */
    /*      LN0425 - ROLLBACK ADDED TO ERROR HANDLING                */
    /*      LN0302 - CLEAR OUT &PARAMETERS                           */
    /*                                                               */
    /*****************************************************************/
    /*                                                               */
    /*  THIS PROGRAM WILL CALL PROGRAMS TO DISPLAY THE RELEVANT      */
    /*  PROMPT SCREENS TO REQUEST A PERIODIC REPORT WITH OR WITHOUT  */
    /*  A MODULE SPECIFIC PROMPT                                     */
    /*                                                               */
    /*****************************************************************/
/*********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MODE)
    /*                                                               */
             DCL        VAR(&ROUT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MBREP) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MUREP) TYPE(*CHAR) LEN(1)
             DCL        VAR(&BANK) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DBRN) TYPE(*CHAR) LEN(3)
             DCL        VAR(&FDAY) TYPE(*CHAR) LEN(2)
             DCL        VAR(&OUTQ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ACOF) TYPE(*CHAR) LEN(3)                 /*S01486*/
             DCL        VAR(&DPPT) TYPE(*CHAR) LEN(3)                 /*S01486*/
             DCL        VAR(&HLVS) TYPE(*CHAR) LEN(1)                 /*S01486*/
             DCL        VAR(&ACDP) TYPE(*CHAR) LEN(2)                 /*S01486*/
             DCL        VAR(&SELECT) TYPE(*CHAR) LEN(6)               /*S01486*/
/*/COPY WNCPYSRC,FCC0210001                                          */
    /*                                                                 *LN0488*/
             DCL        VAR(&PARMX) TYPE(*CHAR) LEN(100)              /*LN0488*/
    /*                                                                 *LN0488*/
/*/COPY WNCPYSRC,FCC0210002                                          */
             DCL        VAR(&PARMS) TYPE(*CHAR) LEN(100)
             DCL        VAR(&PNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PARAMETERS) TYPE(*CHAR) LEN(100)
             DCL        VAR(&ACTION) TYPE(*CHAR) LEN(1)
/*           DCL        VAR(&SEL) TYPE(*CHAR) LEN(100)                /*S01486*/
             DCL        VAR(&SEL) TYPE(*CHAR) LEN(350)                /*S01486*/
    /*                                                               */
             DCL        VAR(&BRANCH) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&CMD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MIDQ) TYPE(*CHAR) LEN(1)
    /*                                                               */
             DCL        VAR(&DSFDY) TYPE(*CHAR) LEN(200)
             DCL        VAR(&DSSDY) TYPE(*CHAR) LEN(800)              /*S01486*/
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&SBPARMS) TYPE(*CHAR) LEN(213)
             DCL        VAR(&STRING) TYPE(*CHAR) LEN(268)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
                                                                      /*LN1165*/
             DCL        VAR(&MBIN) TYPE(*CHAR) LEN(1)
/************DCL        VAR(&OLDNAME) TYPE(*CHAR) LEN(10)      /*049424*076789*/
/************DCL        VAR(&IBMLVL) TYPE(*CHAR) LEN(6)        /*049424*076789*/
/************DCL        VAR(&NEWNAME) TYPE(*CHAR) LEN(10)      /*049424*076789*/
/************DCL        VAR(&VALUE) TYPE(*CHAR) LEN(50)        /*049424*076789*/
/************DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(7)        /*049424*076789*/
             DCL       VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*FIRST ') /*092725*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                /*092725*/
             DCL        VAR(&CODPM) TYPE(*CHAR) LEN(1)                /*092725*/
                                                                      /*LN1165*/
/* */
/* DECLARE PERIODIC REQUESTS FILE TO DEFINE PARAMETER FIELDS         */
/* */
             DCLF       FILE(FCPREQPD)
/* */
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             CHGJOB     SWS(00000000)
                                                                      /*LN1165*/
/*/COPY WNCPYSRC,FCC0210003                                          */
/**/
/* ACCESS MULTI-BRANCHING INDICATOR FROM RUNDAT DATA AREA */
/**/
             RTVDTAARA  DTAARA(RUNDAT (13 1)) RTNVAR(&MBIN)
                                                                      /*LN1165*/
    /*                                                               */
             RTVJOBA    USER(&USER)
/*           CALL       PGM(AOUSERR0) PARM('*DBERR' '*KEY' &USER +
                          &DSFDY)                                     /*S01486*/
/*           CHGVAR   &BANK (%SST(&DSFDY 94 1))                       /*S01486*/
/*           CHGVAR   &DBRN (%SST(&DSFDY 105 3))                      /*S01486*/
/*           CHGVAR   &MUREP (%SST(&DSFDY 104 1))                     /*S01486*/
/*           CHGVAR   &MBREP (%SST(&DSFDY 108 1))                     /*S01486*/
/*           CHGVAR   &ROUT (%SST(&DSFDY 103 1))                      /*S01486*/
/*           CHGVAR   &OUTQ (%SST(&DSFDY 122 10))                     /*S01486*/
                                                                      /*S01486*/
/*  Account Officer and Department */                                 /*S01486*/
             CALL       PGM(AOUSERR0) PARM('*DBERR' '*KEY' &USER +
                          &DSSDY)                                     /*S01486*/
             CHGVAR   &BANK (%SST(&DSSDY 94 1))                       /*S01486*/
             CHGVAR   &DBRN (%SST(&DSSDY 105 3))                      /*S01486*/
             CHGVAR   &MUREP (%SST(&DSSDY 104 1))                     /*S01486*/
             CHGVAR   &MBREP (%SST(&DSSDY 108 1))                     /*S01486*/
             CHGVAR   &ROUT (%SST(&DSSDY 103 1))                      /*S01486*/
             CHGVAR   &OUTQ (%SST(&DSSDY 122 10))                     /*S01486*/
             CHGVAR   &ACOF (%SST(&DSSDY 199 3))                      /*S01486*/
             CHGVAR   &DPPT (%SST(&DSSDY 100 3))                      /*S01486*/
                                                                      /*S01486*/
/* Access Portfolio Management ICD for High Level Security indicator  /*S01486*/
                                                                      /*S01486*/
/*     Portfolio Management    = (&FMT 65) is 'Y'                     /*092725*/
                                                                      /*092725*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*092725*/
             CALL       PGM(AOMMODR0) PARM(&RTCD &OPTN &FMT)          /*092725*/
/*     Database error handling                                        /*092725*/
             IF         COND(&RTCD *NE '       ') THEN(DO)            /*092725*/
             SNDPGMMSG  MSG('Error on access to ICD file AOMMODPD') +
                          TOMSGQ(MOPERQ MRUNQ)                        /*092725*/
             GOTO ABNOR                                               /*092725*/
             ENDDO                                                    /*092725*/
                                                                      /*092725*/
             CHGVAR     VAR(&CODPM) VALUE(%SST(&FMT 65 1))            /*092725*/
                                                                      /*092725*/
             IF         COND(&CODPM *EQ 'Y') THEN(DO)                 /*092725*/
             CALL     PGM(AOPORTR0) PARM('*DBERR' '*FIRST' &DSFDY)    /*S01486*/
             CHGVAR   &HLVS (%SST(&DSFDY 12 1))                       /*S01486*/
             ENDDO                                                    /*092725*/
             ELSE       CMD(CHGVAR VAR(&HLVS) VALUE('N'))             /*092725*/
/*                                                                    /*S01486*/
/*                                                                 */
/* OPEN INPUT FILE TO SUBFILE DISPLAY PROGRAM TO SHOW ONLY THOSE   */
/* RECORDS USER IS AUTHORISED TO SEE: OWN USER IF NOT AUTHORISED   */
/* TO MULTIPLE USERS; OWN BRANCH (AT BRANCH LEVEL) IF NOT          */
/* AUTHORISED TO MULTIPLE BRANCHES                                 */
/*                                                                 */
             OVRDBF     FILE(FCPREQL1) SHARE(*YES)
                                                                      /*LN1165*/
/**/
/* CHANGE VARIABLE &SEL FOR USE IN OPNQRYF:- */
/* CONDITION DIFFERENT SELECT VALUES DEPENDING ON MULTIBRANCH IND */
/**/
/* IF MULTIBRANCHING IS PRESENT IN THE SYSTEM */
/**/
                                                                      /*S01486*/
                                                                      /*S01486*/
/* The following code is ignored and has been replaced with code */   /*S01486*/
/* that includes checks for Account Officer and Department. */        /*S01486*/
                                                                      /*S01486*/
GOTO SELECT                                                           /*S01486*/
                                                                      /*S01486*/
      IF         COND(&MBIN *EQ 'Y') THEN(DO)
/*                                                                 */
/* IF NOT AUTHORISED TO MULTIPLE USERS */
/* BUT AUTHORISED TO MULTIPLE BRANCHES THEN */
/* SELECT ALL PERIODIC RECORDS FOR REQUESTING USER */
/**/
                                                                      /*LN1165*/
             IF         COND((&MUREP *EQ 'N') *AND (&MBREP *EQ 'Y')) +
                          THEN(CHGVAR VAR(&SEL) VALUE('D9USRR *EQ "' +
                          *CAT &USER *CAT '"'))
/*                                                                 */
                                                                      /*LN1165*/
/* IF NOT AUTHORISED TO MULTIPLE BRANCHES */
/* BUT AUTHORISED TO MULTIPLE USERS THEN */
/* SELECT ALL PERIODIC RECORDS FOR BRANCH OF USER */
                                                                      /*LN1165*/
             IF         COND((&MBREP *EQ 'N') *AND (&MUREP *EQ 'Y')) +
                          THEN(CHGVAR VAR(&SEL) VALUE('(D9LVL *EQ +
                          "B") *and (D9ETTY *EQ "' *CAT &DBRN *CAT +
                          '")'))
/*                                                                 */
                                                                      /*LN1165*/
/* IF NOT AUTHORISED TO MULTIPLE BRANCHES AND */
/* NOT AUTHORISED TO MULTIPLE USERS THEN */
/* SELECT ALL PERIODIC RECORDS USER AT OWN BRANCH */
                                                                      /*LN1165*/
             IF         COND((&MBREP *EQ 'N') *AND (&MUREP *EQ 'N')) +
                          THEN(CHGVAR VAR(&SEL) VALUE('(D9LVL *EQ +
                          "B") *AND (D9ETTY *EQ "' *CAT &DBRN *CAT +
                          '") *AND (D9USRR *EQ "' *CAT &USER *CAT +
                          '")'))
/*                                                                 */
                                                                      /*LN1165*/
/* IF USER IS EITHER NOT AUTHORISED TO MULTIPLE USERS */
/* OR NOT AUTHORISED TO MULTIPLE BRANCHES */
/* THEN SELECT OUT RECORDS USING OPNQRYF */
                                                                      /*LN1165*/
             IF         COND((&MUREP *EQ 'N') *OR (&MBREP *EQ 'N')) +
                          THEN(OPNQRYF FILE((FCPREQL1)) QRYSLT(&SEL) +
                          KEYFLD(*FILE) SEQONLY(*YES 1))
                                                                      /*LN1165*/
      ENDDO
/**/
/* IF IN A SINGLE BRANCH ENVIRONMENT AND */
/* USER IS NOT AUTHORISED TO MULTIPLE USERS */
/* THEN SELECT OUT OWN RECORDS USING OPNQRYF */
/**/
      IF         COND((&MBIN *EQ 'N') *AND (&MUREP *EQ 'N'))  +
      THEN(DO)
             CHGVAR     VAR(&SEL) VALUE('(D9USRR *EQ "' *CAT &USER +
                          *CAT '")')
             OPNQRYF    FILE((FCPREQL1)) QRYSLT(&SEL) KEYFLD(*FILE) +
                          SEQONLY(*YES 1)
      ENDDO
                                                                      /*LN1165*/
                                                                      /*S01486*/
SELECT:                                                               /*S01486*/
                                                                      /*S01486*/
  /* 1. Multibranching Indicator.                                     /*S01486*/
  /* 2. Multiple Branches Reports off Midas Users' file.              /*S01486*/
  /* 3. Multiple Users Reports off Midas Users' file.                 /*S01486*/
  /* 4. High Level Security off Portfolio Management ICD.             /*S01486*/
  /* 5. How Account Officer and Department off Midas Users's is set up/*S01486*/
  /*        *A = Account Officer is 'ALL'.                            /*S01486*/
  /*        AC = specific Account Officer is specified.               /*S01486*/
  /*        DP = specific Department Officer is specified.            /*S01486*/
  /*                                                                  /*S01486*/
  /* 1 ¦ 2 ¦ 3 ¦ 4 ¦ 5  ¦     Selection                               /*S01486*/
  /*------------------------------------------------------------------/*S01486*/
  /* N ¦ - ¦ N ¦ N ¦    ¦ User.                                       /*S01486*/
  /* N ¦ - ¦ N ¦ Y ¦ *A ¦ User.                                       /*S01486*/
  /* N ¦ - ¦ N ¦ Y ¦ AC ¦ User & Level S or User & Level A & Entity AC/*S01486*/
  /* N ¦ - ¦ N ¦ Y ¦ DP ¦ User & Level S or User and Level A or User &/*S01486*/
  /*                       Level D & Entity DP.                       /*S01486*/
  /* N ¦ - ¦ Y ¦ N ¦    ¦ No open query file selection required.      /*S01486*/
  /* N ¦ - ¦ Y ¦ Y ¦ *A ¦ No open query file selection required.      /*S01486*/
  /* N ¦ - ¦ Y ¦ Y ¦ AC ¦ Level S or Level A and Entity AC.           /*S01486*/
  /* N ¦ - ¦ Y ¦ Y ¦ DP ¦ Level S or Level A or Level D and Entity DP./*S01486*/
  /* Y ¦ N ¦ N ¦ N ¦    ¦ User and Level B and Entity Default Branch  /*S01486*/
  /*                      or User and Level A or User and Level D.    /*S01486*/
  /* Y ¦ N ¦ N ¦ Y ¦ *A ¦ User and Level B and Entity Default Branch  /*S01486*/
  /*                      User and Level A or User and Level D.       /*S01486*/
  /* Y ¦ N ¦ N ¦ Y ¦ AC ¦ User and level B and Entity Default Branch  /*S01486*/
  /*                      or User and level A and Entity AC.          /*S01486*/
  /* Y ¦ N ¦ N ¦ Y ¦ DP ¦ User and Level B and Entity Default Branch o/*S01486*/
  /*                      User & Level A or User & Level D & Entiy DP./*S01486*/
  /* Y ¦ N ¦ Y ¦ N ¦    ¦ Level B and Entity Default Branch or Level A/*S01486*/
  /*                      or Level D.                                 /*S01486*/
  /* Y ¦ N ¦ Y ¦ Y ¦ *A ¦ Level B and Entity Default Branch or Level A/*S01486*/
  /*                      or Level D.                                 /*S01486*/
  /* Y ¦ N ¦ Y ¦ Y ¦ AC ¦ Level B and Entity Default Branch or Level A/*S01486*/
  /*                      and Entity AC.                              /*S01486*/
  /* Y ¦ N ¦ Y ¦ Y ¦ DP ¦ Level B and Entity Default Branch or Level A/*S01486*/
  /*                      or Level D and Entity DP.                   /*S01486*/
  /* Y ¦ Y ¦ N ¦ N ¦    ¦ User.                                       /*S01486*/
  /* Y ¦ Y ¦ N ¦ Y ¦ *A ¦ User.                                       /*S01486*/
  /* Y ¦ Y ¦ N ¦ Y ¦ AC ¦ User and Level S or User and Level C or User/*S01486*/
  /*                      and Level B or User and Level A and Entity A/*S01486*/
  /* Y ¦ Y ¦ N ¦ Y ¦ DP ¦ User and Level S or User and Level C or User/*S01486*/
  /*                      and Level B or User and Level A or User and /*S01486*/
  /*                      Level D and Entity DP.                      /*S01486*/
  /* Y ¦ Y ¦ Y ¦ N ¦    ¦ No open query file selection required.      /*S01486*/
  /* Y ¦ Y ¦ Y ¦ Y ¦ *A ¦ No open query file selection required.      /*S01486*/
  /* Y ¦ Y ¦ Y ¦ Y ¦ AC ¦ Level S or Level C or Level B or Level A    /*S01486*/
  /*                      and Entity AC.                              /*S01486*/
  /* Y ¦ Y ¦ Y ¦ Y ¦ DP ¦ Level S or Level C or Level B or Level A    /*S01486*/
  /*                      or Level D and Entity DP.                   /*S01486*/
  /*                                                                  /*S01486*/
  /* Set up defaults for selection criteria                           /*S01486*/
             CHGVAR     VAR(&SEL) VALUE(' ')                          /*S01486*/
             CHGVAR     VAR(&ACDP) VALUE('  ')                        /*S01486*/
  /*                                                                  /*S01486*/
  /**  Set up criteria 5 of the selection criteria                    /*S01486*/
  /*                                                                  /*S01486*/
         IF         COND(&HLVS *EQ 'Y') THEN(DO)                      /*S01486*/
                                                                      /*S01486*/
             IF   COND(&ACOF = 'ALL') THEN(CHGVAR VAR(&ACDP) +
                  VALUE('*A'))                                        /*S01486*/
  /*                                                                  /*S01486*/
             IF         COND((&ACOF *NE 'ALL') *AND (&ACOF *NE '   +
                          ')) THEN(CHGVAR VAR(&ACDP) VALUE('AC'))     /*S01486*/
  /*                                                                  /*S01486*/
             IF         COND((&ACOF = '   ') *AND (&DPPT *NE '   ') +
                          *AND (&DPPT *NE 'ALL')) THEN(CHGVAR +
                          VAR(&ACDP) VALUE('DP'))                     /*S01486*/
         ENDDO                                                        /*S01486*/
  /*                                                                  /*S01486*/
  /** For Multibranching off, multiple branch report indicator */     /*S01486*/
  /** is not required. */                                             /*S01486*/
  /*                                                                  /*S01486*/
             IF         COND(&MBIN = 'N') THEN(CHGVAR VAR(&MBREP) +
                          VALUE(' '))                                 /*S01486*/
  /*                                                                  /*S01486*/
  /** Concatenate all the conditions together. */                     /*S01486*/
  /*                                                                  /*S01486*/
             CHGVAR     VAR(&SELECT) VALUE(&MBIN *CAT &MBREP *CAT +
                          &MUREP *CAT &HLVS *CAT &ACDP)               /*S01486*/
  /*                                                                  /*S01486*/
                                                                      /*S01486*/
  /* Determine the OPNQRYF selection parameter                        /*S01486*/
  /*                                                                  /*S01486*/
             IF   COND(&SELECT = 'N NN  ') THEN(DO)                   /*S01486*/
             CHGVAR     VAR(&SEL) VALUE('(D9USRR *EQ "' *CAT &USER +
                          *CAT '")')                                  /*S01486*/
             ENDDO                                                    /*S01486*/
                                                                      /*S01486*/
             IF   COND(&SELECT = 'N NY*A') THEN(DO)                   /*S01486*/
             CHGVAR     VAR(&SEL) VALUE('(D9USRR *EQ "' *CAT &USER +
                          *CAT '")')                                  /*S01486*/
             ENDDO                                                    /*S01486*/
                                                                      /*S01486*/
             IF   COND(&SELECT = 'N NYAC') THEN(DO)                   /*S01486*/
             CHGVAR     VAR(&SEL) VALUE('((D9USRR *EQ "' *CAT &USER +
                          *CAT '") *AND (D9LVL = "S")) *OR ((D9USRR +
                          *EQ "' *CAT &USER *CAT '") *AND (D9LVL = +
                          "A") *AND (D9ETTY *EQ "' *CAT &ACOF *CAT +
                          '"))')                                      /*S01486*/
             ENDDO                                                    /*S01486*/
                                                                      /*S01486*/
             IF   COND(&SELECT = 'N NYDP') THEN(DO)                   /*S01486*/
             CHGVAR     VAR(&SEL) VALUE('((D9USRR *EQ "' *CAT &USER +
                          *CAT '") *AND (D9LVL = "S")) *OR ((D9USRR +
                          *EQ "' *CAT &USER *CAT '") *AND (D9LVL = +
                          "A")) *OR ((D9USRR *EQ "' *CAT &USER *CAT +
                          '") *AND (D9LVL = "D") *AND (D9ETTY *EQ +
                          "' *CAT &DPPT *CAT '"))')                   /*S01486*/
             ENDDO                                                    /*S01486*/
                                                                      /*S01486*/
             IF   COND(&SELECT = 'N YYAC') THEN(DO)                   /*S01486*/
             CHGVAR     VAR(&SEL) VALUE('(D9LVL = "S") *OR ((D9LVL = +
                          "A") *AND (D9ETTY *EQ "' *CAT &ACOF *CAT +
                          '"))')                                      /*S01486*/
             ENDDO                                                    /*S01486*/
                                                                      /*S01486*/
             IF   COND(&SELECT = 'N YYDP') THEN(DO)                   /*S01486*/
             CHGVAR     VAR(&SEL) VALUE('(D9LVL = "S") *OR (D9LVL = +
                          "A") *OR ((D9LVL = "D") *AND (D9ETTY *EQ +
                          "' *CAT &DPPT *CAT '"))')                   /*S01486*/
             ENDDO                                                    /*S01486*/
                                                                      /*S01486*/
             IF   COND(&SELECT = 'YNNN  ') THEN(DO)                   /*S01486*/
             CHGVAR     VAR(&SEL) VALUE('((D9USRR *EQ "' *CAT &USER +
                          *CAT '") *AND (D9LVL = "B") *AND (D9ETTY +
                          *EQ "' *CAT &DBRN *CAT '")) *OR ((D9USRR +
                          *EQ "' *CAT &USER *CAT '") *AND (D9LVL = +
                          "A")) *OR ((D9USRR *EQ "' *CAT &USER *CAT +
                          '") *AND (D9LVL = "D"))')                   /*S01486*/
             ENDDO                                                    /*S01486*/
                                                                      /*S01486*/
             IF   COND(&SELECT = 'YNNY*A') THEN(DO)                   /*S01486*/
             CHGVAR     VAR(&SEL) VALUE('((D9USRR *EQ "' *CAT &USER +
                          *CAT '") *AND (D9LVL = "B") *AND (D9ETTY +
                          *EQ "' *CAT &DBRN *CAT '")) *OR ((D9USRR +
                          *EQ "' *CAT &USER *CAT '") *AND (D9LVL = +
                          "A")) *OR ((D9USRR *EQ "' *CAT &USER *CAT +
                          '") *AND (D9LVL = "D"))')                   /*S01486*/
             ENDDO                                                    /*S01486*/
                                                                      /*S01486*/
             IF   COND(&SELECT = 'YNNYAC') THEN(DO)                   /*S01486*/
             CHGVAR     VAR(&SEL) VALUE('((D9USRR *EQ "' *CAT &USER +
                          *CAT '") *AND (D9LVL = "B") *AND (D9ETTY +
                          *EQ "' *CAT &DBRN *CAT '")) *OR ((D9USRR +
                          *EQ "' *CAT &USER *CAT '") *AND (D9LVL = +
                          "A") *AND (D9ETTY *EQ "' *CAT &ACOF *CAT +
                          '"))')                                      /*S01486*/
             ENDDO                                                    /*S01486*/
                                                                      /*S01486*/
             IF   COND(&SELECT = 'YNNYDP') THEN(DO)                   /*S01486*/
             CHGVAR     VAR(&SEL) VALUE('((D9USRR *EQ "' *CAT &USER +
                          *CAT '") *AND (D9LVL = "B") *AND (D9ETTY +
                          *EQ "' *CAT &DBRN *CAT '")) *OR ((D9USRR +
                          *EQ "' *CAT &USER *CAT '") *AND (D9LVL = +
                          "A")) *OR ((D9USRR *EQ "' *CAT &USER *CAT +
                          '") *AND (D9LVL = "D") *AND (D9ETTY *EQ +
                          "' *CAT &DPPT *CAT '"))')                   /*S01486*/
             ENDDO                                                    /*S01486*/
                                                                      /*S01486*/
             IF   COND(&SELECT = 'YNYN  ') THEN(DO)                   /*S01486*/
             CHGVAR     VAR(&SEL) VALUE('((D9LVL = "B") *AND (D9ETTY +
                          *EQ "' *CAT &DBRN *CAT '")) *OR (D9LVL = +
                          "A") *OR (D9LVL = "D")')                    /*S01486*/
             ENDDO                                                    /*S01486*/
                                                                      /*S01486*/
             IF   COND(&SELECT = 'YNYY*A') THEN(DO)                   /*S01486*/
             CHGVAR     VAR(&SEL) VALUE('((D9LVL = "B") *AND (D9ETTY +
                          *EQ "' *CAT &DBRN *CAT '")) *OR (D9LVL = +
                          "A") *OR (D9LVL = "D")')                    /*S01486*/
             ENDDO                                                    /*S01486*/
                                                                      /*S01486*/
             IF   COND(&SELECT = 'YNYYAC') THEN(DO)                   /*S01486*/
             CHGVAR     VAR(&SEL) VALUE('((D9LVL = "B") *AND (D9ETTY +
                          *EQ "' *CAT &DBRN *CAT '")) *OR ((D9LVL = +
                          "A") *AND (D9ETTY *EQ "' *CAT &ACOF *CAT +
                          '"))')                                      /*S01486*/
             ENDDO                                                    /*S01486*/
                                                                      /*S01486*/
             IF   COND(&SELECT = 'YNYYDP') THEN(DO)                   /*S01486*/
             CHGVAR     VAR(&SEL) VALUE('((D9LVL = "B") *AND (D9ETTY +
                          *EQ "' *CAT &DBRN *CAT '")) *OR (D9LVL = +
                          "A") *OR ((D9LVL = "D") *AND (D9ETTY *EQ +
                          "' *CAT &DPPT *CAT '"))')                   /*S01486*/
             ENDDO                                                    /*S01486*/
                                                                      /*S01486*/
             IF         COND(&SELECT = 'YYNN  ') THEN(DO)             /*S01486*/
             CHGVAR     VAR(&SEL) VALUE('(D9USRR *EQ "' *CAT &USER +
                          *CAT '")')                                  /*S01486*/
             ENDDO                                                    /*S01486*/
                                                                      /*S01486*/
             IF   COND(&SELECT = 'YYNY*A') THEN(DO)                   /*S01486*/
             CHGVAR     VAR(&SEL) VALUE('(D9USRR *EQ "' *CAT &USER +
                          *CAT '")')                                  /*S01486*/
             ENDDO                                                    /*S01486*/
                                                                      /*S01486*/
             IF   COND(&SELECT = 'YYNYAC') THEN(DO)                   /*S01486*/
             CHGVAR     VAR(&SEL) VALUE('((D9USRR *EQ "' *CAT &USER +
                          *CAT '") *AND (D9LVL = "S")) *OR ((D9USRR +
                          *EQ "' *CAT &USER *CAT '") *AND (D9LVL = +
                          "C")) *OR ((D9USRR *EQ "' *CAT &USER +
                          *CAT '") *AND (D9LVL = "B")) *OR ((D9USRR +
                          *EQ "' *CAT &USER *CAT '") *AND (D9LVL = +
                          "A") *AND (D9ETTY *EQ "' *CAT &ACOF *CAT +
                          '"))')                                      /*S01486*/
             ENDDO                                                    /*S01486*/
                                                                      /*S01486*/
             IF   COND(&SELECT = 'YYNYDP') THEN(DO)                   /*S01486*/
             CHGVAR     VAR(&SEL) VALUE('((D9USRR *EQ "' *CAT &USER +
                          *CAT '") *AND (D9LVL = "S")) *OR ((D9USRR +
                          *EQ "' *CAT &USER *CAT '") *AND (D9LVL = +
                          "C")) *OR ((D9USRR *EQ "' *CAT &USER *CAT +
                          '") *AND (D9LVL = "B")) *OR ((D9USRR *EQ +
                          "' *CAT &USER *CAT '") *AND (D9LVL = +
                          "A")) *OR ((D9USRR *EQ "' *CAT &USER *CAT +
                          '") *AND (D9LVL = "D") *AND (D9ETTY *EQ +
                          "' *CAT &DPPT *CAT '"))')                   /*S01486*/
             ENDDO                                                    /*S01486*/
                                                                      /*S01486*/
             IF   COND(&SELECT = 'YYYYAC') THEN(DO)                   /*S01486*/
             CHGVAR     VAR(&SEL) VALUE('(D9LVL = "S") *OR (D9LVL = +
                          "C") *OR (D9LVL = "B") *OR ((D9LVL = "A") +
                          *AND (D9ETTY *EQ "' *CAT &ACOF *CAT +
                          '"))')                                      /*S01486*/
             ENDDO                                                    /*S01486*/
                                                                      /*S01486*/
             IF   COND(&SELECT = 'YYYYDP') THEN(DO)                   /*S01486*/
             CHGVAR     VAR(&SEL) VALUE('(D9LVL = "S") *OR (D9LVL = +
                          "C") *OR (D9LVL = "B") *OR (D9LVL = "A") +
                          *OR ((D9LVL = "D") *AND (D9ETTY *EQ "' +
                          *CAT &DPPT *CAT '"))')                      /*S01486*/
             ENDDO                                                    /*S01486*/
                                                                      /*S01486*/
             IF         COND(&SEL *NE ' ') THEN(OPNQRYF +
                          FILE((FCPREQL1)) QRYSLT(&SEL) +
                          KEYFLD(*FILE) SEQONLY(*YES 1))              /*S01486*/
                                                                      /*S01486*/
/*                                                                 */
 DSPF:
/*                                                                 */
/* BLANK OUT PARAMETER FIELDS WHICH ARE NOT DEFAULTED/RESET IN RPG */
/*                                                                 */
             CHGVAR     VAR(&RTCD) VALUE('       ')
             CHGVAR     VAR(&CMD) VALUE(' ')
             CHGVAR     VAR(&D9PSQN) VALUE('  ')
             CHGVAR     VAR(&FDAY) VALUE('  ')
             CHGVAR     VAR(&ACTION) VALUE(' ')
             CHGVAR     VAR(&D9FREQ) VALUE(' ')
             CHGVAR     VAR(&D9COTT) VALUE('          ')
             CHGVAR     VAR(&D9RNAM) VALUE('          ')
             CHGVAR     VAR(&D9CSEQ) VALUE('     ')
             CALL       PGM(FC0210D) PARM(&RTCD &MODE &DBRN &D9RNAM +
                          &D9PSQN &D9COTT &D9CSEQ &ACTION &MUREP &MBREP)
    /*                                                               */
             IF         COND(&RTCD *EQ 'Y2U9999') THEN(GOTO +
                          CMDLBL(THEEND))
    /*                                                               */
 FIRST:      CALL       PGM(FC0210) PARM(&D9RNAM &D9PSQN &D9COTT +
                          &D9CSEQ &D9PDSC &D9USRR &D9FREQ &FDAY +
                          &D9PFDT &D9LVL &D9ETTY &D9DRQD &BANK +
                          &MBREP &MUREP &DBRN &ACTION &CMD &D9SOID +
                          &MIDQ &D9TNLU)
    /*                                                               */
    /* IF DATABASE ERROR OCCURRED                                    */
    /*                                                               */
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(DBEND))
    /*                                                               */
    /* IF F3 IS TAKEN                                                */
    /*                                                               */
             IF         COND(&CMD = 'P') THEN(GOTO CMDLBL(DSPF))
             IF         COND(&CMD = 'E') THEN(GOTO CMDLBL(THEEND))
    /*                                                               */
    /* GET PROMPT PROGRAM NAME AND PARAMETERS FOR REPORT             */
    /*                                                               */
             CALL       PGM(FC0030) PARM(&D9RNAM &D9COTT &D9CSEQ +
                          &PARMS &PNAM)
    /*                                                               */
    /* IF DATABASE ERROR OCCURRED                                    */
    /*                                                               */
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(DBEND))
    /*                                                               */
             IF         COND((&PNAM *NE '          ') *AND (&CMD *NE +
                          'D')) THEN(DO)
             IF         COND((&ACTION *EQ 'I') *AND (&MBIN *EQ 'N')) +
                           THEN(CHGVAR VAR(&D9LVL) VALUE(' '))       /*E46848*/
    /*                                                                 *LN0488*/
    /*  IF AN AMEND OR ENQUIRY,GET ORIGINAL PARAMETERS FROM FCPARPPD   *LN0488*/
    /*                                                                 *LN0488*/
             IF         COND((&ACTION *EQ 'A') *OR (&ACTION *EQ 'E')  +
                              *OR (&ACTION *EQ 'D')) THEN(DO)         /*LN0488*/
    /*                                                                 *LN0488*/
                CALL PGM(FC0211) PARM(&D9RNAM &D9PSQN &PARMX)         /*LN0488*/
    /*                                                                 *LN0488*/
                IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                             CMDLBL(DBEND))                           /*LN0488*/
    /*                                                                 *LN0488*/
/*/COPY WNCPYSRC,FCC0210004                                          */
                CHGVAR     VAR(&PARAMETERS) VALUE(&PARMX)             /*LN0488*/
/*/COPY WNCPYSRC,FCC0210005                                          */
             ENDDO                                                    /*LN0488*/
    /*                                                                 *LN0488*/
/**********     CALL       PGM(&PNAM) PARM('' &D9LVL &D9ETTY +          E38898*/
/**********                  &PARAMETERS &ACTION &CMD)                  E38898*/
 PROMPT:     CHGVAR     VAR(&CMD) VALUE(' ')                          /*E38898*/
/*/COPY WNCPYSRC,FCC0210006                                          */
                CALL       PGM(&PNAM) PARM('' &D9LVL &D9ETTY +
                             &PARAMETERS &ACTION &CMD)                /*E38898*/
/*/COPY WNCPYSRC,FCC0210007                                          */
                IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                             CMDLBL(DBEND))
                IF         COND(&CMD = 'E') THEN(GOTO +
                             CMDLBL(THEEND))
/***************IF         COND(&CMD = 'F') THEN(GOTO +
                             CMDLBL(FIRST))                           /*096786*/
                IF         COND(&CMD = 'F') THEN(DO)                  /*096786*/
                             CHGVAR VAR(&PARAMETERS) VALUE(' ')       /*096786*/
                             GOTO   CMDLBL(FIRST)                     /*096786*/
                ENDDO                                                 /*096786*/
             ENDDO
/**/
/**CHECK*THAT*PROGRAM*IS*RUNNING*ON*IBM*VERSION*2*****/    /*044847*/ /*049424*/
/**IF*ONE*OF*THE*FILES*EXISTS,*THEN*ALL*OF*THEM*WILL**/    /*044847*/ /*049424*/
/**IF*THEY*DO,*THEN*OVERRIDE*THE*FILES****************/    /*044847*/ /*049424*/
/**/                                                                  /*044847*/
/*********** CHKOBJ     OBJ(QAOKDY01) OBJTYPE(*FILE)       /*044847*/ /*049424*/
/*********** MONMSG  MSGID(CPF9801) EXEC(GOTO CMDLBL(MAIN))/*044847*/ /*049424*/
 
/*********** OVRDBF     FILE(QAOKDP01) TOFILE(QAOKDY01)    /*044847*/ /*049424*/
/*********** MONMSG     MSGID(CPF0000)                     /*044847*/ /*049424*/
 
/*********** OVRDBF     FILE(QAOKLP02) TOFILE(QAOKLY02)    /*044847*/ /*049424*/
/*********** MONMSG     MSGID(CPF0000)                     /*044847*/ /*049424*/
 
/*********** OVRDBF     FILE(QAOKDL01) TOFILE(QAOKDG01)    /*044847*/ /*049424*/
/*********** MONMSG     MSGID(CPF0000)                     /*044847*/ /*049424*/
 
/* CHECK FOR RENAMED IBM FILES AND SETUP OVERRIDES IF NECCESSARY */   /*049424*/
 
/* DETERMINE THE MACHINE OPERATING SYSTEM LEVEL */                    /*049424*/
                                                                      /*049424*/
/******RTVDTAARA  DTAARA(QSYS/QSS1MRI (1 6)) RTNVAR(&IBMLVL)   /*049424*076789*/
                                                                      /*049424*/
/* CHECK FOR FILE PF/QAOKDP01 */                                      /*049424*/
                                                                      /*049424*/
/************CHGVAR     VAR(&OLDNAME) VALUE(QAOKDP01)        /*049424 /*074789*/
                                                                      /*049424*/
/************CALL       PGM(AOIBMDR0) PARM(&RTNCDE '*KEY' &IBMLVL +
/************             &OLDNAME &VALUE)                     /*049424*076789*/
                                                                      /*049424*/
/************IF         COND(&RTNCDE *NE '*NRF') THEN(DO)      /*049424*076789*/
/************CHGVAR VAR(&NEWNAME) VALUE(%SST(&VALUE 17 10))    /*049424*076789*/
/************   OVRDBF     FILE(&OLDNAME) TOFILE(&NEWNAME)     /*049424*076789*/
/************ENDDO                                             /*049424*076789*/
                                                                      /*049424*/
/* CHECK FOR FILE PF/QAOKLP02 */                                      /*049424*/
                                                                      /*049424*/
/************CHGVAR     VAR(&OLDNAME) VALUE(QAOKLP02)          /*049424*076789*/
                                                                      /*049424*/
/************CALL       PGM(AOIBMDR0) PARM(&RTNCDE '*KEY' &IBMLVL +
/************             &OLDNAME &VALUE)                     /*049424*076789*/
                                                                      /*049424*/
/************IF         COND(&RTNCDE *NE '*NRF') THEN(DO)      /*049424*076789*/
/************CHGVAR VAR(&NEWNAME) VALUE(%SST(&VALUE 17 10))    /*049424*076789*/
/************   OVRDBF     FILE(&OLDNAME) TOFILE(&NEWNAME)     /*049424*076789*/
/************ENDDO                                             /*049424*076789*/
/* CHECK FOR FILE LF/QAOKDL01 */                                      /*049424*/
                                                                      /*049424*/
/************CHGVAR     VAR(&OLDNAME) VALUE(QAOKDL01)          /*049424*076789*/
                                                                      /*049424*/
/************CALL       PGM(AOIBMDR0) PARM(&RTNCDE '*KEY' &IBMLVL +
/************             &OLDNAME &VALUE)                     /*049424*076789*/
                                                                      /*049424*/
/************IF         COND(&RTNCDE *NE '*NRF') THEN(DO)      /*049424*076789*/
/************CHGVAR VAR(&NEWNAME) VALUE(%SST(&VALUE 17 10))    /*049424*076789*/
/************   OVRDBF     FILE(&OLDNAME) TOFILE(&NEWNAME)     /*049424*076789*/
/************ENDDO                                             /*049424*076789*/
                                                                      /*049424*/
/*/COPY WNCPYSRC,FCC0210008                                          */
 MAIN:       CALL       PGM(FC0215) PARM(&D9RNAM &D9COTT &D9CSEQ +
                          &D9PDSC &MIDQ &D9USRR &D9FREQ &FDAY +
                          &D9PFDT &D9LVL &D9ETTY &D9DRQD &D9PSQN +
                          &ACTION &D9TNLU &D9SOID &PARAMETERS &CMD +
                          &ROUT &OUTQ &MUREP &DBRN)
/*/COPY WNCPYSRC,FCC0210009                                          */
 
/************DLTOVR     FILE(QAOKDP01 QAOKLP02 QAOKDL01)       /*044847*076789*/
/************MONMSG     MSGID(CPF0000)                         /*044847*076789*/
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(DBEND))
             IF         COND(&CMD = 'E') THEN(GOTO +
                          CMDLBL(THEEND))
/**/                                                                  /*LN1279*/
/*   IF F12 IS TAKEN RETURN TO PREVIOUS SCREEN                                */
/**/
/**********  IF         COND(&CMD = 'F') THEN(GOTO +                    E38898*/
/**********               CMDLBL(FIRST))                                E38898*/
/************IF         COND(&CMD *EQ 'F' *AND &PNAM *EQ '          ')  +
                           THEN(GOTO CMDLBL(FIRST))             E38898  096786*/
             IF         COND(&CMD *EQ 'F' *AND &PNAM *EQ '          ')  +
                           THEN(DO)                                   /*096786*/
                        CHGVAR VAR(&PARAMETERS) VALUE(' ')            /*096786*/
                        GOTO CMDLBL(FIRST)                            /*096786*/
             ENDDO                                                    /*096786*/
             IF         COND(&CMD *EQ 'F' *AND &PNAM *NE '          ')  +
                           THEN(GOTO CMDLBL(PROMPT))                  /*E38898*/
/**/                                                                  /*LN1279*/
             CHGVAR     VAR(&PARAMETERS) VALUE(' ')                   /*LN0302*/
             GOTO       CMDLBL(DSPF)
    /*                                                               */
/**/
/*   FOR DATABASE ERRORS RECOVER DATA FROM LDA                       */
/**/
 DBEND:      IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA *ALL) RTNVAR(&LDA)
                CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
/**/                                                                  /*LN0425*/
                ROLLBACK                                              /*LN0425*/
/**/                                                                  /*LN0425*/
                GOTO       ABNOR
             ENDDO
    /*                                                              */
    /*                                                              */
 ABNOR:      SNDPGMMSG  MSG('R.C.F Periodic Requests Maintenance - +
                          Terminated Abnormally') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO +
                          CMDLBL(THEEND))
 THEEND:     RCLRSC
             CLOF       OPNID(FCPREQL1)
             MONMSG     MSGID(CPF0000 MCH0000)
             DLTOVR     FILE(FCPREQL1)
             MONMSG     MSGID(CPF0000 MCH0000)
             ENDPGM
