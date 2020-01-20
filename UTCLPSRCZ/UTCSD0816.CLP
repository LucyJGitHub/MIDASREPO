/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('SD MD-39572 Utility program')                         */
/*********************************************************************/
/*                                                                   */
/*     Midas - UTILITY                                               */
/*                                                                   */
/*     UTCSD0816  -  SD MD-39572 Utility program                     */
/*                                                                   */
/*       (c) Finastra International Limited 2020                     */
/*                                                                   */
/*       Last Amend No. MD039572 *CREATE   Date 14Jan20              */
/*********************************************************************/
/*                                                                   */
/*  MD039572 - Failed component during COB - COMPONENT DLC0606C      */
/*********************************************************************/
             PGM

 /* Print SDNARRPD Report */
             CALL       PGM(UTSD0816)

 /* Print ACKEYAL Report  */
             CALL       PGM(UTSD0817)

 /* Print GLCOAKPD Report  */
             CALL       PGM(UTSD0818)

 /* Print SEACKD Report  */
             CALL       PGM(UTSD0819)
             ENDPGM
