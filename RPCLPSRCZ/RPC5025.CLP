/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas TrOpics I/face - FX Rates Upload Request')      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Replication                                         */
/*                                                                   */
/*       RPC5025 - Midas TrOpics I/face - Generic Download           */
/*                                                                   */
/*       (C) COPYRIGHT Misys International Banking Systems sa. 2001  */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. 240075             Date 30Jun06              */
/*       Prev Amend No. CSD026             Date 05Apr05              */
/*                      UTROPX  *Create    Date 11DEC01              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       240075 - Submit job under xxOWNER not the signed on user.   */
/*       CSD026 - Midas-TrOpics Interface upgrade to MidasPlus       */
/*       UTROPX - Midas-TrOpics Interface.                           */
/*                                                                   */
/*********************************************************************/
             PGM
 
/**********  SBMJOB     CMD(CALL PGM(RPC5026)) JOB(FXRATERQS) +
                          JOBD(TIJOBD) JOBQ(TIJOBQ)                                       /*240075*/
             SBMJOB     CMD(CALL PGM(RPC5026)) JOB(FXRATERQS) +
                          JOBD(TIJOBD) JOBQ(TIJOBQ) USER(*JOBD)                           /*240075*/
/* End of Program:                                                 */
TAG999:
             ENDPGM
