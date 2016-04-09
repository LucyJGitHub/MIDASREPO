/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(UP001704) VLDCKR(*NONE) MSGF(UTMSGF)                    */
/*EXI    HLPPNLGRP(UPT_WIPCF)  HLPID(UPT_WIPCF)                      */
/*EXI *  TEXT('Midas UP Initialise T_WIPCF for all zones')           */
/*********************************************************************/
/*                                                                   */
/*       Midas - Bridge                                              */
/*                                                                   */
/*       UPT_WIPCF - Initialise T_WIPCF for All Zones.               */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2004           */
/*                                                                   */
/*       Last Amend No. BUG27884           Date 08Jul10              */
/*       Prev Amend No. BUG15756           Date 05Feb08              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      BG4033 *CREATE     Date 17Aug04              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       BUG27884 - Applied 15756. (Recompile)                       */
/*       BUG15756 - To retain 'GLOBAL' value in WC_ZONE.             */
/*       BG4033 - New command for T_WIPCF data initialisation.       */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Initialise WIP Config File')
