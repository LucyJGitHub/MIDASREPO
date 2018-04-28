/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Create request file of Telekur numbers')     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Securities Trading Module                           */
/*                                                                   */
/*       SEC5980 - Create Request File of Telekurs no. (Servitia)    */
/*                                                                   */
/*       Function: Create a file containing the telekur nos. of      */
/*                 securities w/ position and those securities       */
/*                 w/out position but have been requested.           */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CSE067             Date 25Apr05              */
/*       Prev Amend No. CSC023             Date 02Feb04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CPK014             Date 14Nov01              */
/* Midas DBA 3.02 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CSE009             Date 16Mar99              */
/*                      110242             Date 07Nov96              */
/*                      083954             DATE 28MAR95              */
/*                      S01502  *CREATE    DATE 08JUL94              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CSE067 - Telekurs Interface Changes                         */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CPK014 - Submit jobs with user *JOBD                        */
/*       CSE009 - Telekurs Changes                                   */
/*       110242 - Change defaults for SBMJOB cmd to take *JOBD       */
/*       083954 - Interim fix change name of telekurs                */
/*                communication program                              */
/*       S01502 - BLI Telekurs Processing.                           */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
/*/COPY WNCPYSRC,SEC5980001                                          */
             DCL        VAR(&SESTAT) TYPE(*CHAR) LEN(133)
             DCL        VAR(&TELK)   TYPE(*CHAR) LEN(7) VALUE('       ')                  /*CSE009*/
             DCL        VAR(&OPTN)   TYPE(*CHAR) LEN(7) VALUE('*FIRST ')                  /*CSE009*/
             DCL        VAR(&SAR)    TYPE(*CHAR) LEN(6)                                   /*CSE009*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)                                 /*CSE009*/
             DCL        VAR(&DAYS) TYPE(*DEC) LEN(5 0)                                    /*CSE009*/
                                                                                          /*CSE009*/
             DCLF       FILE(SDBANKPD)                                                    /*CSE009*/
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ERROR))
             RTVDTAARA  DTAARA(SESTAT) RTNVAR(&SESTAT)
 
             IF         COND(%SST(&SESTAT 129 1) *EQ 'N') THEN(GOTO +
                          CMDLBL(END))
/*/COPY WNCPYSRC,SEC5980002                                          */
 
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(00000000)
                                                                                          /*CSE009*/
             OVRDBF     FILE(SDBANKPD) SHARE(*NO)                                         /*CSE009*/
             RCVF                                                                         /*CSE009*/
             CHGVAR     VAR(&DAYS) VALUE(&BJRDNB)                                         /*CSE009*/
                                                                                          /*CSE009*/
             CHGVAR     VAR(&TELK) VALUE('       ')                                       /*CSE009*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CSE009*/
             CHGVAR     VAR(&SAR)  VALUE('CSE009')                                        /*CSE009*/
                                                                                          /*CSE009*/
             CALL       PGM(AOSARDR0) PARM(&TELK &OPTN &SAR &SCSARD)                      /*CSE009*/
 
/**/
/* CHECK IF RERUN                                                    */
/**/
             ALCOBJ     OBJ((SESTAT *DTAARA *EXCL))
             RTVDTAARA  DTAARA(SESTAT) RTNVAR(&SESTAT)
 
/**/
/* CREATE EXTRACT FILE                                               */
/**/
/*/COPY WNCPYSRC,SEC5980003                                          */
             IF         COND((%SST(&SESTAT 132 1) *EQ 'N')) THEN(DO)
/********    CLRPFM     FILE(STSECPO2)                                 */                 /*CSE009*/
/*/COPY WNCPYSRC,SEC5980004                                          */
             IF         COND((&TELK *EQ '       ') *OR (&DAYS >= +
                          09978)) THEN(CLRPFM FILE(SETKSEPD))                             /*CSE009*/
             ELSE       CMD(CLRPFM FILE(STSECPO2))                                        /*CSE009*/
 
/**/
/* CHANGED FOR SECURITIES TRADING II                                 */
/**/
             OPNQRYF    FILE((DPOSN)) QRYSLT('RECI *EQ "D" *AND DSNV +
                        *NE 0 *AND DSNT *NE 0') KEYFLD((DSSC) (DDPT))
 
             CALL       PGM(SE5980)
             CLOF       OPNID(DPOSN)
 
/**/
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA                         */
/**/
             IF    COND(%SWITCH(XXXXXX11)) THEN(DO)
                   RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                   CHGVAR VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))
                   SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                   TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                   GOTO CMDLBL(END)
             ENDDO
 
/**/
/* ADD IN ANY USER REQUESTED SECURITY TELEKUR NUMBERS                */
/**/
             IF         COND((&TELK *EQ '       ') *OR (&DAYS >= +
                          09978)) THEN(DO)                                                /*CSE009*/
                CPYF       FROMFILE(SETKEXPD) TOFILE(SETKSEPD) +
                             MBROPT(*ADD)                                                 /*CSE009*/
                MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                                 /*CSE009*/
             ENDDO                                                                        /*CSE009*/
             ELSE CMD(DO)                                                                 /*CSE009*/
/*/COPY WNCPYSRC,SEC5980005                                          */
        CPYF       FROMFILE(STSTKPF2) TOFILE(STSECPO2) MBROPT(*ADD)
/*/COPY WNCPYSRC,SEC5980006                                          */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ENDDO                                                                        /*CSE009*/
 
/**/
/* DELETE ANY DUPLICATE TELEKUR NUMBERS                              */
/**/
             IF         COND((&TELK *EQ '       ') *OR (&DAYS >= +
                          09978)) THEN(DO)                                                /*CSE009*/
                CLRPFM     FILE(SETKWRPD)                                                 /*CSE009*/
                CHGJOB     SWS(01000000)                                                  /*CSE009*/
             ENDDO                                                                        /*CSE009*/
             ELSE CMD(DO)                                                                 /*CSE009*/
/*/COPY WNCPYSRC,SEC5980007                                          */
             CLRPFM     FILE(STSECPF2)
/*/COPY WNCPYSRC,SEC5980008                                          */
             CHGJOB     SWS(10000000)                                                     /*CSE009*/
             ENDDO                                                                        /*CSE009*/
                                                                                          /*CSE009*/
             CALL       PGM(SE5981)
                                                                                          /*CSE009*/
             IF         COND((&TELK *EQ '       ') *OR (&DAYS >= +
                          09978)) THEN(DO)                                                /*CSE009*/
                CPYF       FROMFILE(SETKWRPD) TOFILE(SETKSEPD) +
                             MBROPT(*REPLACE)                                             /*CSE009*/
                MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                                 /*CSE009*/
             ENDDO                                                                        /*CSE009*/
             ELSE CMD(DO)                                                                 /*CSE009*/
/*/COPY WNCPYSRC,SEC5980009                                          */
             CPYF       FROMFILE(STSECPF2) TOFILE(STSECPO2) +
                        MBROPT(*REPLACE)
/*/COPY WNCPYSRC,SEC5980010                                          */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/*/COPY WNCPYSRC,SEC5980015                                          */
             ENDDO                                                                        /*CSE009*/
 
/**/
/* SET FLAG THAT EXTRACT CREATED OK                                  */
/**/
             CHGVAR     VAR(%SST(&SESTAT 132 1)) VALUE('Y')
             CHGDTAARA  DTAARA(SESTAT) VALUE(&SESTAT)
             DLCOBJ OBJ((SESTAT *DTAARA *EXCL))
/*/COPY WNCPYSRC,SEC5980013                                          */
             ENDDO
/*/COPY WNCPYSRC,SEC5980014                                          */
 
             RTVDTAARA  DTAARA(SESTAT) RTNVAR(&SESTAT)
/**/
/* TRANSMISSION TELEKUR FILE TO SERVITIA VIA COMMUNICATION           */
/**/
/*/COPY WNCPYSRC,SEC5980011                                          */
             IF         COND((%SST(&SESTAT 129 1) *EQ 'C')) THEN(DO)
/*********** SBMJOB     JOB(TELEKURS) JOBD(MBATCH) RQSDTA('CALL +  */
/***********              CLENVSER')                               */ /*083954*/
/************SBMJOB     JOB(TELEKURS) JOBD(MBATCH) RQSDTA('CALL +     /*110242*/
/*************            ICFCCLIA') */                        /*083954 110242*/
/************SBMJOB     JOB(TELEKURS) JOBD(MBATCH) RTGDTA(*JOBD) +                        /*CPK014*/
/************             RQSDTA('CALL ICFCCLIA') INLLIBL(*JOBD)      /*110242*/          /*CPK014*/
/************SBMJOB     JOB(TELEKURS) JOBD(MBATCH) USER(*JOBD) +                          /*CSC023*/
/************             RTGDTA(*JOBD) RQSDTA('CALL ICFCCLIA') +                         /*CSC023*/
/************             INLLIBL(*JOBD)                                       /*CPK014*/ /*CSC023*/
/**********  SBMJOB     JOB(TELEKURS) JOBD(MBATCH) USER(*JOBD) +                          /*CSE067*/
/**********               RTGDTA(*JOBD) RQSDTA('CALL ICFCCLIA') +                         /*CSE067*/
/**********               INLLIBL(*JOBD) OUTQ(*JOBD)                           /*CSC023*/ /*CSE067*/
             SBMJOB     JOB(TELEKURS) JOBD(MBATCH) USER(*JOBD) +
                          RTGDTA(*JOBD) RQSDTA('CALL SEFCCLIA') +
                          INLLIBL(*JOBD) OUTQ(*JOBD)                                      /*CSE067*/
             GOTO       CMDLBL(OK)
             ENDDO
/*/COPY WNCPYSRC,SEC5980012                                          */
/**/
/* LOAD TAPE AND COPY TO DISK                                        */
/**/
 
             IF         COND((%SST(&SESTAT 133 1) *EQ 'N')) THEN(DO)
             DLCOBJ     OBJ((SESTAT *DTAARA *EXCL))
             CALL       PGM(SEC5981)
 
             ALCOBJ     OBJ((SESTAT *DTAARA *EXCL))
             RTVDTAARA  DTAARA(SESTAT) RTNVAR(&SESTAT)
 
             IF         COND((%SST(&SESTAT 133 1) *EQ 'C')) THEN(DO)
             CHGVAR     VAR(%SST(&SESTAT 133 1)) VALUE('N')
             CHGDTAARA  DTAARA(SESTAT) VALUE(&SESTAT)
             DLCOBJ OBJ((SESTAT *DTAARA *EXCL))
             GOTO       CMDLBL(END)
             ENDDO
 
/**/
/* SET FLAG THAT TAPE COPIED TO DISK                                 */
/**/
             CHGVAR     VAR(%SST(&SESTAT 133 1)) VALUE('Y')
             ENDDO
 
/**/
/* SET FLAG THAT SECURITY UPDATED OK                                 */
/**/
OK:          CHGVAR     VAR(%SST(&SESTAT 132 2)) VALUE('NN')
             GOTO       CMDLBL(END)
 
/**/
ERROR:       SNDPGMMSG  MSG('CREATE TELEKURS FILE - PROGRAM SEC5980 -+
                        ENDED ABNORMALLY') TOPGMQ(*EXT) +
                        TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
/**/
END:         CHGDTAARA  DTAARA(SESTAT) VALUE(&SESTAT)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLCOBJ     OBJ((SESTAT *DTAARA *EXCL))
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
