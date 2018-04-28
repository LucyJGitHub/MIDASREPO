/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Rep Last Sucs. Trans on Primary Mach')          */
/********************************************************************/
/*                                                                  */
/*        Midas     - Restart Recovery Module                   */
/*                                                                  */
/*       SDC1761 - Check that Input Cycle Initiation was complete   */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. 086140             DATE  29MAR95            */
/*       PREV AMEND NO. S01343             DATE  15AUG91            */
/*                      E13205             DATE  14/02/89           */
/*                      E00000             DATE  00/00/00           */
/*                                                                  */
/********************************************************************/
/*       New program overview                                       */
/*                                                                  */
/*       086140 - Look for BJ entry from program ICIFINISH          */
/*       S01343 - SC/RR/SD MODULE RENAME PROJECT.                   */
/*                - SCC01 RENAMED FROM SDC01                        */
/*       E13205 - Find the last 'BJ' entry for program SCC01/SDC1755*/
/*                if not found pass back a negative number          */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&SEQN)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
/*           Declare variables                                       */
/**/
             DCL        VAR(&SEQN) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&RTNSEQNBR) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&RTNJRNE) TYPE(*CHAR) LEN(500)
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(7)
/**/
/*           Global Monitor message                                  */
/**/
             MONMSG     MSGID(MCH0000 CPF0000) EXEC(GOTO CMDLBL(ABNOR))
/**/
/************Retrieve*journal*entry*for*SDC01                         /*S01343*/
/*           Retrieve journal entry for SCC01                         /*S01343*/
/**/
/************RTVJRNE    JRN(*LIBL/ICJRN) RCVRNG(*LIBL/ICRCV001 +
/************             *CURRENT) FROMENT(*FIRST) TOENT(*LAST) +
/************             SEARCH(*ASCEND) JRNCDE(U) ENTTYP(BJ) +
/************             JOB(*ALL) PGM(SDC01) RTNSEQNBR(&RTNSEQNBR) +
/************             RTNJRNE(&RTNJRNE)                           /*S01343*/
/************                                                          *086140*/
/************RTVJRNE    JRN(*LIBL/ICJRN) RCVRNG(*LIBL/ICRCV001 +       *086140*/
/************             *CURRENT) FROMENT(*FIRST) TOENT(*LAST) +     *086140*/
/************             SEARCH(*ASCEND) JRNCDE(U) ENTTYP(BJ) +       *086140*/
/************             JOB(*ALL) PGM(SCC01) RTNSEQNBR(&RTNSEQNBR) + *086140*/
/************             RTNJRNE(&RTNJRNE)01) RTNSEQNBR(&RTNSEQNBR) + *S01343*/
/************                                                          *086140*/
             RTVJRNE    JRN(*LIBL/ICJRN) RCVRNG(*LIBL/ICRCV001 +
                          *CURRENT) FROMENT(*FIRST) TOENT(*LAST) +
                          SEARCH(*ASCEND) JRNCDE(U) ENTTYP(BJ) +
                          JOB(*ALL) PGM(ICIFINISH) +
                          RTNSEQNBR(&RTNSEQNBR) RTNJRNE(&RTNJRNE)     /*086140*/
/*                        JOB(*ALL) PGM(SCC01) RTNSEQNBR(&RTNSEQNBR) +  086140*/
/*                        RTNJRNE(&RTNJRNE)                    /*S01343 086140*/
/**/
/*           If no entry received try to find it via SDC1755         */
/**/
             MONMSG     MSGID(CPF7073) EXEC(DO)
/**/
/*           Retrieve journal entry for SDC1755                      */
/**/
             RTVJRNE    JRN(*LIBL/ICJRN) RCVRNG(*LIBL/ICRCV001 +
                          *CURRENT) FROMENT(*FIRST) TOENT(*LAST) +
                          SEARCH(*ASCEND) JRNCDE(U) ENTTYP(BJ) +
                          JOB(*ALL) PGM(SDC1755) +
                          RTNSEQNBR(&RTNSEQNBR) RTNJRNE(&RTNJRNE)
/**/
/*           If no entry received set sequence number to -1          */
/**/
             MONMSG     MSGID(CPF7073) EXEC(DO)
             CHGVAR     VAR(&SEQN) VALUE(-1)
             GOTO       CMDLBL(END)
             ENDDO
             ENDDO
/**/
/*           Change sequence number to retrieved number              */
/**/
             CHGVAR     VAR(&SEQN) VALUE(&RTNSEQNBR)
/**/
             GOTO       CMDLBL(END)
/**/
 ABNOR:      SNDPGMMSG  MSG('PROGRAM SDC1761 - Check that Input Cycle +
                          initiation was complete  - ENDED +
                          ABNORMALLY') TOPGMQ(*EXT) +
                          TOMSGQ(*LIBL/MOPERQ *LIBL/MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
END:         ENDPGM
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/**/
