/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas IR FACILITIES AND GUARANTEES')                  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Italian Returns Module                              */
/*                                                                   */
/*       IRC4000 - FACILITIES AND GUARANTEES                         */
/*                                                                   */
/*       (C) Copyright Midas-Kapiti International Ltd. 1999          */
/*                                                                   */
/*       Last Amend No. MD058100           Date 20May21              */
/*       Prev Amend No. LUC139 *Amend      Date 30Apr21              */
/*                      LUC139 *Amend      Date 28Apr21              */
/*                      LUC139             Date 21Dec20              */
/*                      MBV006             Date  7Oct09              */
/*                      261936             Date 17Sep09              */
/*                      MBV002             Date 11Apr02              */
/*                      MMI091             Date 27Dec01              */
/*                      MMI033  *create         22Aug00              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD058100 - Rollup of additional BoI onsite fixes at FbMidas */
/*       LUC139 - Always call IR4001 irrespective of CLE006 being on */
/*                or off.                                            */
/*       LUC139 - Suppress IR4011/12/13/14                           */
/*       LUC139 - Upgrade UCI Italian Returns                        */
/*       MBV006 - HVB - Extract Loan IQ transactions.                */
/*       261936 - Fields 6001 and 6003 on main loan should be        */
/*                reduced by corresponding fields of parts sold.     */
/*       MBV002 - HVB Changes                                        */
/*       MMI091 - Puma enhancements December 2001                    */
/*       MMI033 - Bank Of Italy Monthly Reporting                    */
/*                                                                   */
/*********************************************************************/

             PGM

             DCL VAR(&SAR) TYPE(*CHAR) LEN(6)
             DCL VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL VAR(&OPT) TYPE(*CHAR) LEN(7)

             CLRPFM     FILE(IRFCLTPD)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(IRGUARPD)
             MONMSG     MSGID(CPF0000)
/**********                                                            *LUC139*/
/* If CLE006 is on call IR4000, else IR4001                            *LUC139*/
/**********                                                            *LUC139*/
/**********  CHGVAR VAR(&OPT) VALUE('*VERIFY')                         *LUC139*/
/**********  CHGVAR VAR(&SAR) VALUE('CLE006')                          *LUC139*/
/**********  CALL PGM(AOSARDR0) PARM(&RTCD &OPT &SAR)                  *LUC139*/
/**********  IF         COND(&RTCD *EQ '       ') THEN(DO)             *LUC139*/
/**********  CALL       PGM(IR4000)                                    *LUC139*/
/**********  ENDDO                                                     *LUC139*/
/**********  ELSE       CMD(CALL PGM(IR4001))                          *LUC139*/

             CALL       PGM(IR4001)                                   /*LUC139*/

/*           OVRDBF     FILE(IRPUMAPD) TOFILE(*LIBL/IRPUMAPD)      */ /*MMI091*/
/*           OPNQRYF    FILE((IRPUMAPD)) FORMAT(IRPUMAPD) +
                          QRYSLT('MKUIA *EQ "205"') KEYFLD((MK207))*/ /*MMI091*/
             OPNQRYF    FILE((IRPUMAPD)) OPTION(*ALL) +
                          FORMAT(IRPUMAPD) QRYSLT('MKUIA *EQ +
                          "205"') KEYFLD((MK207))                     /*MMI091*/

             CALL  PGM(IR4010)

/*           DLTOVR     FILE(IRPUMAPD)                             */ /*MMI091*/
             CLOF       OPNID(IRPUMAPD)

/***********                                                                               *LUC139*/
/**Repo*extraction *                                                                       *LUC139*/
/***********                                                                               *LUC139*/
/*********** CLRPFM     FILE(IRRIPOPD)                                                     *LUC139*/
/*********** MONMSG     MSGID(CPF0000)                                                     *LUC139*/
/***********                                                                               *LUC139*/
/*********** CLRPFM     FILE(IRRIPMPD)                                                     *LUC139*/
/*********** MONMSG     MSGID(CPF0000)                                                     *LUC139*/
/***********                                                                               *LUC139*/
/*********** CLRPFM     FILE(IRRIPTPD)                                                     *LUC139*/
/*********** MONMSG     MSGID(CPF0000)                                                     *LUC139*/

/*********** CALL  PGM(IR4014)                                                             *LUC139*/

/*********** CALL  PGM(IR4013)                                                             *LUC139*/

/*********** CALL  PGM(IR4011)                                                             *LUC139*/

/*********** CALL  PGM(IR4012)                                                             *LUC139*/

             CALL  PGM(IR4019)                                        /*MBV002*/

             DLTOVR     FILE(*ALL)
                                                                      /*261936*/
/* Reduce Numbers for participations sold */                          /*261936*/
                                                                      /*261936*/
             CALL       PGM(IR4020)                                   /*261936*/
                                                                      /*MBV006*/
/* Aggregate fields 6001/3 for renewed loans */                       /*MBV006*/
                                                                      /*MBV006*/
             CALL       PGM(IR4021)                                   /*MBV006*/

             ENDPGM
