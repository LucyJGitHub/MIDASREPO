/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(SMC000054)   VLDCKR(SMC000054V)  MSGF(UTMSGF)           */
/*EXI    HLPPNLGRP(*NONE)                                            */
/*EXI    TEXT('Midas SM Change CCSID for multiple libraries')        */
/*********************************************************************/
/*                                                                   */
/*       Midas - Implementation                                      */
/*                                                                   */
/*       CHGCCSIDSM - Change CCSIDs for multiple libraries           */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2008           */
/*                                                                   */
/*       Last Amend No. MD020013           Date 11Apr13              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Prev Amend No. 256038             Date 06Aug08              */
/*                      BG18582  *CREATE   Date 10Apr08              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD020013 - Change the way that the job is submitted.        */
/*       256038  - Change utility so that it will automatically do   */
/*                 complete database.                                */
/*       BG18582 - Enhancements to changing CCSIDs.                  */
/*                                                                   */
/*********************************************************************/
/**********  CMD        PROMPT('Compare database attributes')                          */ /*256038*/
             CMD        PROMPT('Change CCSIDs for database')                              /*256038*/
 
/**********  PARM       KWD(LIBS) TYPE(*CHAR) LEN(10) MIN(1) MAX(10) +                 */ /*256038*/
/**********               PROMPT('Libraries')                                          */ /*256038*/
 
             PARM       KWD(LAYER) TYPE(*CHAR) LEN(7) RSTD(*YES) +
                          VALUES(*ZONE *GLOBAL) MIN(1) MAX(1) +
                          PROMPT('System layer')                                          /*256038*/
 
             PARM       KWD(PFX) TYPE(*CHAR) LEN(2) MIN(1) MAX(1) +
                          PROMPT('System prefix')                                         /*256038*/
 
             PARM       KWD(CCSID) TYPE(*CHAR) LEN(5) DFT(*HEX) +
                          RANGE(1 65535) SPCVAL((*HEX 65535)) +
                          PROMPT('CCSID')
 
/**********  PARM       KWD(SBMJOB) TYPE(*CHAR) LEN(4) RSTD(*YES) +                  */ /*MD020013*/
/**********               DFT(*NO) VALUES(*NO *YES) PMTCTL(*PMTRQS) +                */ /*MD020013*/
/**********               PROMPT('Submit job ?')                              */ /*256038 MD020013*/
 
/**********  PARM       KWD(JOBD) TYPE(*CHAR) LEN(10) MIN(0) +                       */ /*MD020013*/
/**********               PMTCTL(*PMTRQS) PROMPT('Job description')           */ /*256038 MD020013*/
 
