/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CG UDC Control message create for CGPNARMSG')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - User Defined Correspondence                         */
/*                                                                   */
/*       CGADDCTL - Control set up of Posting Narrative Messages     */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. 109175             DATE 16Feb98              */
/*       Prev Amend No. 101582             DATE 06Jan98              */
/*                      101709             DATE 29APR97              */
/*                      089745             DATE 27JUN95              */
/*                      084057             DATE 01MAR95              */
/*                      S01522             DATE 24Feb95              */
/*                                                                   */
/*********************************************************************/
/*   NOTE- When inserting code for a new message, please check for   */
/*         any changes required in CLP/CGTSTCTL as well.             */
/*********************************************************************/
/*                                                                   */
/*       109175 - Add 00880/881/890/900/910/920/930/940/950/960      */
/*       101582 - Change GB00070                                     */
/*       101709 - Incorrect message id for Retail a/c posting        */
/*                narrative.  New one added to message file.         */
/*       089745 - Add GB01001 for FT and correct GB01000             */
/*       084057 - Add new message for SE2450                         */
/*       S01522 - User Defined Correspondence                        */
/*                                                                   */
/*********************************************************************/
   PGM        PARM(&LGID)
 
   DCL        VAR(&LGID) TYPE(*CHAR) LEN(2)
   DCL        VAR(&MGNUM)  TYPE(*CHAR) LEN(5)
   DCL        VAR(&MSGTXT) TYPE(*CHAR) LEN(132)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00000' +
                          '.                                          -
                                                                 ')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00010' '&4 TRADING +
                          IMBALANCE &5 &7')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00020' '&4 ACCRUAL +
                          SUMMARY')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00030' +
                          'SUS&6&7&8-&9 &1')
 
/* 084057    CALL       PGM(CGADDMSG) PARM(&LGID '00031' +
                          'SUS&6&7&8-&9 &16')                 084057 */
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00031' +
                          'SUS&6&7&8-&9 &16 &17')          /* 084057 */
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00032' +
                          'SUS&6&7&8-&9 &1 &17')           /* 084057 */
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00040' 'SPOT +
                          REVALUATION')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00050' 'FORWARD +
                          REVALUATIONS')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00060' 'TRANSFER +
                          F/C INCOME+EXPENSE')
 
/************CALL       PGM(CGADDMSG) PARM(&LGID '00070' 'TRANSFER */ /*101582*/
/************             FROM &6&7&8&9')                          */ /*101582*/
             CALL       PGM(CGADDMSG) PARM(&LGID '00070' 'TRANS +
                          FROM &6&7&8&9')                             /*101582*/
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00080' 'TRANSFER +
                          TO P&L')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00090' +
                          'INTERBRANCH - BATCH BRANCH')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00100' +
                          'INTERBRANCH - ENTRIES BRANCH')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00110' +
                          'INTERBRANCH - MAIN/ENTRIES BR')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00120' +
                          'INTERBRANCH - MAIN/BATCH BRCH')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00130' 'Charge for +
                          Numbered Account')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00140' 'No. A/c +
                          Charge to SUS &6')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00150' 'Charge for +
                          Hold Mail')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00160' 'Hold Mail +
                          Charge to SUS &6')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00170' 'Statement +
                          Charges')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00180' 'Fixed +
                          Account Charges')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00190' 'Interest +
                          Adjustment')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00191' 'Interest +
                          Adjustment &25')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00192' 'Int Adj +
                          &5-&6&7&8-&9')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00200' 'Interest')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00201' 'Interest +
                          &25')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00202' 'Interest +
                          &5-&6&7&8-&9')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00210' 'Charges')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00211' 'Charges &25')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00212' 'Charges +
                          &5-&6&7&8-&9')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00220' 'Accruals')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00221' 'Accruals +
                          &25')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00222' 'Accruals +
                          &5-&6&7&8-&9')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00230' 'Closure')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00231' 'Closure &25')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00232' 'Closure +
                          &5-&6&7&8-&9')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00240' +
                          'Withholding Taxes')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00241' +
                          'Withholding Taxes &25')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00242' 'W/Taxes +
                          &5-&6&7&8-&9')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00250' 'Total Debit')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00251' 'Total +
                          Debit &25')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00252' 'Total DR +
                          &5-&6&7&8-&9')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00260' 'Total +
                          Credit')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00261' 'Total +
                          Credit &25')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00262' 'Total CR +
                          &5-&6&7&8-&9')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00270' 'Total CR +
                          Subject to Tax')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00271' 'Total CR +
                          Subj Tax &25')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00272' 'Subj Tax +
                          &5-&6&7&8-&9')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00280' 'Total CR +
                          Not Subject to Tax')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00281' 'Tot. CR +
                          Not Subj &25')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00282' 'No Tax CR +
                          &5-&6&7&8-&9')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00290' 'Basic Rate +
                          Tax on Interest')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00291' 'BRT +
                          Interest on &25')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00292' 'BRT Int. +
                          &5-&6&7&8-&9')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00300' 'Fixed +
                          Commission')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00301' 'Fixed +
                          Commission &25')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00302' 'Fixed Com +
                          &5-&6&7&8-&9')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00310' 'Account +
                          Commission')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00311' 'Account +
                          commission &25')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00312' 'A/C Com. +
                          &5-&6&7&8-&9')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00320' 'Commission +
                          on Debit Interest')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00321' 'DR +
                          Interest Comm. &25')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00322' 'Int Com. +
                          &5-&6&7&8-&9')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00330' 'Commission +
                          on Highest O''draft')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00331' 'Highest +
                          O''Draft Com &25')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00332' 'H/O Comm. +
                          &5-&6&7&8-&9')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00340' 'Inactive +
                          Account Charge')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00341' 'Inactive +
                          A/C Charge &25')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00342' 'Inact.Chg +
                          &5-&6&7&8-&9')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00350' 'Minimum +
                          Balance Commission')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00351' 'Min +
                          Balance Comm. &25')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00352' 'Min. Com. +
                          &5-&6&7&8-&9')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00360' 'Turnover +
                          Statement Charge')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00361' 'Extra Stmt +
                          Charge &25')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00362' 'Stmt Chg +
                          &5-&6&7&8-&9')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00370' '** VAT **')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00371' '** VAT ** +
                          &25')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00372' '** VAT ** +
                          &5-&6&7&8-&9')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00375' +
                          '                                       +
                          RATE CHANGE')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00380' 'ACCR.A/C +
                          &5-&6&7&8-&9')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00390' 'SETTLEMENT +
                          EXERCISE')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00400' 'SETTLEMENT +
                          TRADE')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00410' 'INTERNAL +
                          BOOK - &23')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00420' '&4 +
                          INTERBCH &1 &24')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00430' 'POSN. +
                          SETTLEMENT RE &1')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00440' 'TAX +
                          DEDUCTED BY USER')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00450' 'Amount +
                          Accruals')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00460' 'Amount +
                          Accruals')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00470' 'Forward +
                          Revaluations')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00480' 'Forward +
                          Revaluations')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00490' 'SPOT +
                          Revaluations')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00500' 'SPOT +
                          Revaluations')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00580' 'Statement +
                          Fees Generation - Retail Account - +
                          Different Account')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00590' 'Fixed +
                          Account Charges - Retail Account - +
                          Different Account')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00660' 'Customer +
                          Exchange - Debit Customer')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00661' 'Customer +
                          Exchange - Debit Customer - Different +
                          Account')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00680' 'Customer +
                          Exchange - Credit Customer')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00681' 'Customer +
                          Exchange - Credit Customer - Different +
                          Account')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00690' 'Forward +
                          Revaluations')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00700' 'Forward +
                          Revaluations')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00710' 'SPOT +
                          Revaluations')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00720' 'SPOT +
                          Revaluations')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00730' 'Debit +
                          Posting')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00731' 'Debit +
                          Posting - Different Account')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00740' 'Credit +
                          Posting')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00741' 'Credit +
                          Posting - Different Account')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00750' 'ACCR.A/C &8')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00752' 'ACCR.A/C &25') +
                                                                      /*101709*/
             CALL       PGM(CGADDMSG) PARM(&LGID '00840' 'Fixed +
                          Account Charges - non Retail Account')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00850' 'Fixed +
                          Account Charges - non Retail Account - +
                          Different Account')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00860' 'Statement +
                          Fees Generation - non Retail Account')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '00870' 'Statement +
                          Fees Generation - non Retail Account - +
                          Different Account')
 CALL   PGM(CGADDMSG) PARM(&LGID '00880' 'TTRAN-&1')                  /*109175*/
 CALL   PGM(CGADDMSG) PARM(&LGID '00881' 'TTRAN-&1_A/C-&25')          /*109175*/
 CALL   PGM(CGADDMSG) PARM(&LGID '00890' 'CASH_WDR_&7_&11')           /*109175*/
 CALL   PGM(CGADDMSG) PARM(&LGID '00900' 'CHEQ_WDR_&7_&11')           /*109175*/
 CALL   PGM(CGADDMSG) PARM(&LGID '00910' 'CASH_DEP_&7_&11')           /*109175*/
 CALL   PGM(CGADDMSG) PARM(&LGID '00920' 'CHEQ_DEP_&7_&11')           /*109175*/
 CALL   PGM(CGADDMSG) PARM(&LGID '00930' '&1_FX - BUY    ')           /*109175*/
 CALL   PGM(CGADDMSG) PARM(&LGID '00940' '&1_FX - SELL   ')           /*109175*/
 CALL   PGM(CGADDMSG) PARM(&LGID '00950' '&1_FX - CHARGE ')           /*109175*/
 CALL   PGM(CGADDMSG) PARM(&LGID '00960' 'BATCH NO. &1 OFFSET')       /*109175*/
/*/COPY WNCPYSRC,CGADDCTL01                                          */
 
/************CALL       PGM(CGADDMSG) PARM(&LGID '01000' '&10')        *089745*/
             CALL       PGM(CGADDMSG) PARM(&LGID '01000' '&1 &10')    /*089745*/
                                                                      /*089745*/
             CALL       PGM(CGADDMSG) PARM(&LGID '01001' '&1')        /*089745*/
 
             CALL       PGM(CGADDMSG) PARM(&LGID '02000' '&1 &28&11')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '03000' '&1 &28&11')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '04000' '&1 DEP INC +
                          TO &3')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '05000' '&1 DEP +
                          REPAY VAL &3')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '06000' '&1 INT DUE +
                          &3')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '07000' '&1 INT &4 +
                          - &5')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '08000' '&1 INT PAY +
                          VAL &3')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '09000' '&1 PURC TO +
                          YLD &13')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '10000' '&1 SALE +
                          VALUE &3')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '11000' '&1 INT TO +
                          &3')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '11001' '&14 INT TO +
                          &3 &1')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '13000' '&1 PROF +
                          VALUE &3')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '15000' '&1 LOSS +
                          VALUE &3')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '17000' '&1 NEW +
                          RATE &12')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '21000' '&1 LOAN +
                          TO  &3')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '22000' '&1 LOAN +
                          REPAY VAL  &3')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '23000' '&1 INT DUE +
                          &3')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '24000' '&1 INT &2 +
                          - &3')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '25000' '&1 DISC +
                          LOAN TO &3')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '26000' '&1 +
                          INTEREST ACCRUED')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '27000' '&1 +
                          DIS/PREM ACCRUED')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '28000' '&1 +
                          INTEREST TAX')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '29000' '&1 +
                          INTEREST TAX')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '30000' '&1 C/F &2 +
                          - &3')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '31000' '&1 +
                          PRINCIPAL DIFF &3')
 
/************CALL       PGM(CGADDMSG) PARM(&LGID '32000' '&1 COMM +    *101709*/
/************             FEE ACCRUED')                                *101709*/
/************                                                          *101709*/
             CALL       PGM(CGADDMSG) PARM(&LGID '32000' '&6 &1 COMM +
                          FEE ACCRUED')                               /*101709*/
                                                                      /*101709*/
             CALL       PGM(CGADDMSG) PARM(&LGID '33000' 'UNREALISED +
                          P/L &16')
 
/************CALL       PGM(CGADDMSG) PARM(&LGID '34000' 'COMM FEE +   *101709*/
/************             ACCRUED')                                    *101709*/
/************                                                          *101709*/
             CALL       PGM(CGADDMSG) PARM(&LGID '34000' '&6 &1 FEE +
                          ACCRUED')                                   /*101709*/
                                                                      /*101709*/
             CALL       PGM(CGADDMSG) PARM(&LGID '35000' 'PRINCIPAL +
                          INCREASE &3')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '36000' 'MGMT FEE +
                          &15')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '44000' '&16 &1')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '45000' 'INTEREST +
                          ON &16')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '46000' 'COUPON RE +
                          &16')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '47000' '&1 +
                          SETTLEMENT RE &16')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '48000' '&1 +
                          SETTLEMENT RE &6')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '49000' '&1 +
                          DISCREPANCY &6')
 
             CALL       PGM(CGADDMSG) PARM(&LGID '50000' 'REALISED +
                          P/L RE &16')
 
             CALL       PGM(CGADDMSG) PARM(&LGID 'FA000' '&1 &10')
 
             CALL       PGM(CGADDMSG) PARM(&LGID 'FB000' '&18 &19 +
                          &20 &10')
 
             CALL       PGM(CGADDMSG) PARM(&LGID 'FC000' '&18 &19 &10')
 
             CALL       PGM(CGADDMSG) PARM(&LGID 'FD000' '&1 +
                          COMMISSION')
 
             CALL       PGM(CGADDMSG) PARM(&LGID 'FE000' '&1 CHARGES +
                          DUE')
 
             CALL       PGM(CGADDMSG) PARM(&LGID 'FF000' '&1 PREMIUM +
                          DUE')
 
             CALL       PGM(CGADDMSG) PARM(&LGID 'F1001' '&1 +
                          EXERCISE OPTION')
 
             CALL       PGM(CGADDMSG) PARM(&LGID 'F2001' '&18 &19 +
                          &20 MARGIN CALL')
 
             CALL       PGM(CGADDMSG) PARM(&LGID 'F3001' '&18 &19 +
                          &20 REALISED PROFIT')
 
             CALL       PGM(CGADDMSG) PARM(&LGID 'F4001' '&18 &19 +
                          &20 REALISED LOSS')
 
             CALL       PGM(CGADDMSG) PARM(&LGID 'F5001' '&18 &17')
 
             CALL       PGM(CGADDMSG) PARM(&LGID 'F6001' '&18 &19 +
                          &20 &21 &22')
 
             CALL       PGM(CGADDMSG) PARM(&LGID 'F7001' '&18 &17 &20')
 
             CALL       PGM(CGADDMSG) PARM(&LGID 'F8001' '&1 &17')
 
             CALL       PGM(CGADDMSG) PARM(&LGID 'F9001' '&18 &19')
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
ENDPGM
