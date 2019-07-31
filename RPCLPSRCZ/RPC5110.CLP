/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas TrOpics I/face - Base Rates Upload Request')    */
/*********************************************************************/
/*                                                                   */
/*       Midas - Replication                                         */
/*                                                                   */
/*       RPC5110 - Midas TrOpics I/face - Base Rate UPLOAD Request   */
/*                                                                   */
/*       (C) Copyright Finastra International Limited 2005           */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. 240075             Date 30Jun06              */
/*                      CSD026             Date 05Apr05              */
/*                      UTROPX             Date 16sep02              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       240075 - Submit job under xxOWNER not the signed on user.   */
/*       CSD026 - Midas-TrOpics Interface upgrade to MidasPlus       */
/*       UTROPX - Midas-TrOpics Interface.                           */
/*                                                                   */
/*********************************************************************/
             PGM
 
/**********  SBMJOB     CMD(CALL PGM(RPC5111)) JOB(BSRATERQS) +
                          JOBD(TIJOBD) JOBQ(TIJOBQ)                                       /*240075*/
             SBMJOB     CMD(CALL PGM(RPC5111)) JOB(BSRATERQS) +
                          JOBD(TIJOBD) JOBQ(TIJOBQ) USER(*JOBD)                           /*240075*/
 
/* End of Program:                                                 */
TAG999:
             ENDPGM
