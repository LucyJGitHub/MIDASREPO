000100961220/*********************************************************************/
000200000000/*STD    CLPBASE                                                     */
000300000000/********************************************************************/
000400000000/*                                                                  */
000500040730/*        Midas     - Dealing Module                                */
000600000000/*                                                                  */
000700040730/*       DLCD802 - DAILY EVENTS BY CURRENCY INPUT CYCLE VERSION     */
000800000000/*                                                                  */
000900200627/*       (c) Finastra International Limited 2001                    */
001000901210/*                                                                  */
001001180404/*       Last Amend No. DUG503            Date  08Apr18             */
001002180404/*       Prev Amend No. DUG431            DATE  27Jun05             */
001003180404/*                      DUG405            DATE  30JUL04             */
001004050627/*                      DUG405            DATE  27JUL04             */
001100000000/* Midas Release 4 --------------- Base -----------------------------*/
001200000000/* Midas DBA 3.00 ---------------- Base -----------------------------*/
001300040730/*                      S01408            DATE  13DEC95             */
001400040726/*                      AUS017             DATE 14AUG92             */
001500951213/*                      E40440             DATE 22MAY92             */
001600920825/*                      E22608             DATE 04SEP90             */
001700920825/*                      E193               DATE 22FEB90             */
001800901210/*                      S01117             DATE 02/08/89            */
001900900222/*                      S01179             DATE 12/09/88            */
002000890802/*                      S03220             DATE 16/05/88            */
002100880912/*                      S01129             DATE 03/08/87            */
002200880516/*                      S01098             DATE 22/09/86            */
002300860918/*                                                                  */
002400880516/********************************************************************/
002500860918/*                                                                  */
002501180404/*       DUG503  -  UGB FED CARS Upgrade                            */
002502050627/*       DUG431  -  Amendments to 'Events by Value Date' Report     */
002503040730/*       DUG405  -  Input Cycle Events by Value Date Reporting.     */
002504040730/*                  Upgrade of S20208/S20039 from ABS 2.3 to R4.01. */
002505040809/*                  Commercial Loans part removed.                  */
002506040730/*       *Created   Based on GLC0802B (R4) & GLC9802B (ABS 2.3).    */
002507040730/*                  Remove CORE Hooks to avoid confusion.           */
002508040730/*       DUG405  -  Changes to the Events by Currency report.       */
002509040730/*                  Component now runs core versions - GL0550/551   */
002510040730/*                  and the modified versions GLD055/056.           */
002511040730/*                  Use existing core hooks GLC0802B07 & B09.       */
002600951213/*       S01408 - Addition of core hook GLC0802B01                  */
002700920825/*       AUS017  -  Australian Release - FX/MM Daily Events by      */
002800920825/*                  Customer                                        */
002900920601/*       E40440  -  DOES NOT WORK CORRECTLY FOR SINGLE BRANCH       */
003000910214/*       E22608  -  PROGRAM RENAMED FROM DLC0802B AND ALL DL        */
003100910214/*                  PROGRAMS CALLED RENAMED TO GL                   */
003200900222/*       E193    -  REMOVE NOSEX PROCESSING                         */
003300900222/*       S01196  -  REMOVE LETTERS OF CREDIT (BC)                   */
003400890802/*       S01194  -  NEW STANDING DATA FILES                         */
003500890802/*       S01117  -  RELEASE 10 MULTIBRANCHING                       */
003600880912/*       S01179  -  AS400 CONVERSION                                */
003700880516/*       S03220  -  FUNDS TRANSFER INTERFACE                        */
003800880516/*       S01129  -  INCLUDE FILES REQUIRED FOR SECURITIES TRADING 2 */
003900880516/*       S01098  -  AMENDMENT BLOCKS SELECTED LARGE FILES           */
004000000000/*                                                                  */
004100000000/********************************************************************/
004200860312/*                                                                  */
004300860312/*       C R E A T I O N     P A R A M E T E R S                     */
004400860312/*                                                                   */
004500860312/*********************************************************************/
004800040806             PGM        PARM(&TYPE &RSEQ &RLEV &RENT)                 /*AUS017*/
005000000000/**/
005100000000             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
005200200627                          Finastra International Limited +
005300000000                          2001')
005400040806             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
005600920913             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(2)                 /*AUS017*/
005700040806             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
005800040806             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1) /* RCF level +
005801040806                          flag (S/C/B)             */
005900040806             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3) /* RCF entity +
005901040806                          code (all/comp/bch)                 */
005902040806             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(44)
005903040806             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*DUG405*/
005904040806             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*DUG405*/
005905040806             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                  /*DUG405*/
005906040806             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)             /*DUG405*/
005907180213             DCL        VAR(&DUG503) TYPE(*CHAR) LEN(1) /*DUG503*/
005908040806             DCL        VAR(&DUG405) TYPE(*CHAR) LEN(1)               /*DUG405*/
005909050627             DCL        VAR(&DUG431) TYPE(*CHAR) LEN(1)               /*DUG431*/
006100000000/**/
006300880912             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)               /*S01179*/
006600880912             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)                    /*S01179*/
006700870803/**/                                                                  /*S01129*/
006800000000             CHGJOB     SWS(00000000)
006901040806/**/
006902040806/* SEND PROGRAM MESSAGE.                                         */
006903040806/**/
006904040806             CHGVAR     VAR(&MEM) VALUE('I/C Events by +
006905040806                        Value Date Reporting')
006906040806             SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ) MSGTYPE(*INFO)
006907040806/**/
006908040806/* CALL PROGRAM.                                                 */
006909040806/**/
006910040806             CHGVAR     VAR(&RTCD) VALUE('       ') /*DUG405*/
006911040806             CHGVAR     VAR(&OPTN) VALUE('*VERIFY') /*DUG405*/
006912180213             CHGVAR     VAR(&SAR) VALUE('DUG503') /*DUG405*/
006913180213             CHGVAR     VAR(&DUG503) VALUE('N') /*DUG405*/
006914040806/**  Check if Enhancement is installed */                             /*DUG405*/
006915040806             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD) +
006916040806                          /*DUG405*/
006917040806
006918040806             IF         COND(&RTCD *EQ '       ') THEN(DO)            /*DUG405*/
006919180213                CHGVAR     VAR(&DUG503) VALUE('Y') /*DUG405*/
006920040806             ENDDO                                                    /*DUG405*/
006921050627
006930040806
006931180213             IF         COND(&DUG503 *EQ 'Y') THEN(DO) /*DUG405*/
006932050627
006933050627/* Clear Customer Exchanges Extract File */                           /*DUG431*/
006934050627             CLRPFM     FILE(GLCXXFPP)                                /*DUG431*/
006935050705             CLRPFM     FILE(GLCXXZPP)                                /*DUG431*/
006936050627/* Clear Journal Entries Extract File */                              /*DUG431*/
006937050627             CLRPFM     FILE(GLJEXFPP)                                /*DUG431*/
006938050705             CLRPFM     FILE(GLJEXZPP)                                /*DUG431*/
006939040806
006940040806/* Deal events extract - Input Cycle */
006941040806             CALL       PGM(DLCD607)
006942040806/* SE events extract - Input Cycle */
006943040806             CALL       PGM(SECD101)
006944050627
006946050627
006947050627/* Customer Exchanges Events Extract */                               /*DUG431*/
006948050627             CALL       PGM(GLD010) PARM('I/C' '       ')             /*DUG431*/
006949050627
006950050627/* Journal Entries Events Extract  */                                 /*DUG431*/
006951050627             CALL       PGM(GLD020) PARM('I/C' '       ')             /*DUG431*/
006952050627
010100860724/**/                                                                  /*S01098*/
011813040730
011814040730/*  CALL MODIFIED VERSION OF GL0550 (CALLED GLD955) - CONSOLIDATED */ /*DUG405*/
011815040730/*  -------------------------------------------------------------- */ /*DUG405*/
011816040730/*                                                                 */ /*DUG405*/
011817040730/* With override for DL events */                                     /*DUG405*/
011818040730             CHGJOB     SWS(XXX0XXXX)
011819040809             OVRDBF     FILE(DLEVNIL2) TOFILE(ILEVNIL3)               /*DUG405*/
011820040730/*  Call Consolidated version of value date report */                 /*DUG405*/
011821040804             IF         COND((&RLEV *EQ 'S') *OR (&RLEV *EQ ' ')) +
011823040804                          THEN(CALL PGM(GLD955) PARM(&TYPE &RSEQ))    /*DUG405*/
011825040730             DLTOVR FILE(DLEVNIL2)                                    /*DUG405*/
011826040730
011827040730/* With override for SE events */                                     /*DUG405*/
011828040730             CHGJOB     SWS(XXX1XXXX)
011829040809             OVRDBF     FILE(DLEVNIL2) TOFILE(ILEVNIL4)               /*DUG405*/
011830040730/*  Call Consolidated version of value date report */                 /*DUG405*/
011831040804             IF         COND((&RLEV *EQ 'S') *OR (&RLEV *EQ ' ')) +
011832040804                          THEN(CALL PGM(GLD955) PARM(&TYPE &RSEQ))    /*DUG405*/
011834040730             DLTOVR FILE(DLEVNIL2)                                    /*DUG405*/
011835040730                                                                      /*DUG405*/
012804040730/*  CALL MODIFIED VERSION OF GL0551 (CALLED GLD956) - BY BRANCH    */ /*DUG405*/
012805040730/*  -----------------------------------------------------------    */ /*DUG405*/
012806040730/*                                                                 */ /*DUG405*/
012807040730/* With override for DL events */                                     /*DUG405*/
012808040730             CHGJOB     SWS(XXX0XXXX)
012809040809             OVRDBF     FILE(DLEVNTLI) TOFILE(ILEVNTLJ)               /*DUG405*/
012810040730/*  Call By Branch version of value date report */                    /*DUG405*/
012812040809             IF         COND(&RLEV *EQ 'B') THEN(CALL PGM(GLD956) +
012813040809                          PARM(&TYPE &RSEQ &RENT))                    /*DUG405*/
012815040803             DLTOVR FILE(DLEVNTLI)                                    /*DUG405*/
012816040730
012817040730/* With override for SE events */                                     /*DUG405*/
012818040730             CHGJOB     SWS(XXX1XXXX)
012819040809             OVRDBF     FILE(DLEVNTLI) TOFILE(ILEVNTLK)               /*DUG405*/
012820040730/*  Call By Branch version of value date report */                    /*DUG405*/
012822040809             IF         COND(&RLEV *EQ 'B') THEN(CALL PGM(GLD956) +
012823040809                          PARM(&TYPE &RSEQ &RENT))                    /*DUG405*/
012825040803             DLTOVR FILE(DLEVNTLI)                                    /*DUG405*/
012826040806             ENDDO
012900890802
014700000000             RTVJOBA    SWS(&SWS)
014900000000/**/
015000000000             IF         COND(%SUBSTRING(&SWS 7 2) = '11') THEN(SNDMSG +
015100000000                        MSG('Job terminated - database in error') +
015200000000                        TOMSGQ(MOPERQ))
015300000000/**/
015400000000             IF         COND(%SUBSTRING(&SWS 7 2) = '01') THEN(SNDMSG +
015500000000                        MSG('File controls out of balance') +
015600000000                        TOMSGQ(MOPERQ))
015800000000/**/
015900000000             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
016000200627                          Finastra International Limited')
016100000000             ENDPGM
