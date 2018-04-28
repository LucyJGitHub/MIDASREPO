/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(SMC000050)    VLDCKR(*NONE)      MSGF(UTMSGF)           */
/*EXI *  TEXT('Midas SM ACOD Conversion Populate and Maintenance')   */
/*E*I****HLPPNLGRP(XXNNNNNN)*****HLPID(*CMD)**************************/ /*             */ /*CPK025*/
/*EXI    HLPPNLGRP(ACODCVTMNT)   HLPID(*CMD)                         */                   /*CPK025*/
/*********************************************************************/
/*                                                                   */
/*       Midas - Implementatoin Module                               */
/*                                                                   */
/*       ACODCVTMNT - Convert and Maintain Account Codes Command     */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2004           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CPK025             Date 17Aug06              */
/*       Prev Amend No. CSM007  *CREATE    Date 05Oct05              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CPK025 - Allow more versatile padding of Account Codes.     */
/*                Add panel group help as well.                      */
/*       CSM007 - Conversion of Account Codes                        */
/*                Created to display all the Account Codes and allow */
/*                them to be changed                                 */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Option for 10 Long A/C Codes')
 
             PARM       KWD(ACTION) TYPE(*CHAR) LEN(9) RSTD(*YES) +
                          VALUES(*MAINTAIN *POPULATE) MIN(1) +
                          PROMPT('10 Digit A/C Code Process?' 1)
 
/**********  PARM       KWD(PADDING) TYPE(*CHAR) LEN(7) RSTD(*YES) +                   */ /*CPK025*/
/**********               DFT(*BEFORE) VALUES(*BEFORE *AFTER) +                        */ /*CPK025*/
/**********               MIN(0) PMTCTL(PMTCTL1) PROMPT('Padding?' 2)                  */ /*CPK025*/
             PARM       KWD(LEAD0S) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(0) VALUES(0 1 2 3 4 5 6) MIN(0) +
                          PMTCTL(PMTCTL1) PROMPT('Number of lead +
                          zeros' 2)                                                       /*CPK025*/
 
 PMTCTL1:    PMTCTL     CTL(ACTION) COND((*EQ *POPULATE))
 
