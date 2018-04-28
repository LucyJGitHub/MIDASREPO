/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(UTC000009)  VLDCKR(UTC0030_V)  MSGF(UTMSGF)             */
/*EXI *  TEXT('Midas UT End journaling for all objects in a lib.')   */
/**EXI***HLPPNLGRP(ENDJRNLIB)******HLPID(*CMD)************************/                 /*BUG27135*/
/*EXI    HLPPNLGRP(LIBENDJRN)      HLPID(*CMD)                       */                 /*BUG27135*/
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities                                           */
/*                                                                   */
/*       LIBENDJRN - End journaling for all objects in a library     */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2006           */
/*                                                                   */
/*       Last Amend No. BUG27135           Date 10Mar10              */
/*       Prev Amend No. CUP036  *CREATE    Date 22Nov06              */
/*                      xxxxxx             Date ddMmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BUG27135- Rename ENDJRNLIB to LIBENDJRN                     */
/*       CUP036 - Add automated refreshing for test systems.         */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('End journaling for library')
 
             PARM       KWD(LIBRARY) TYPE(*NAME) LEN(10) MIN(1) +
                          FULL(*NO) PROMPT('Library name')
 
