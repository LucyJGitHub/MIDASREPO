/*********************************************************************/
/*                                                                   */
/*       Last Amend No. EML108             Date 15Jan20              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*   EML108 - Upgrade EML108 to FBM2.1SP21                           */
/*   UMD001 - Upgrade FMD003 to Midas Plus 1.2.1 SP19                */
/*                                                                   */
/*********************************************************************/
/**********  DCL        VAR(&FMD003) TYPE(*CHAR) LEN(1) VALUE('N')   */                   /*EML108*/
             DCL        VAR(&EML108) TYPE(*CHAR) LEN(1) VALUE('N')                        /*EML108*/
/**********  DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE(' ')     */                   /*EML108*/
/**********  DCL        VAR(&DSFDY) TYPE(*CHAR) LEN(200)             */                   /*EML108*/
             DCL        VAR(&MCCCY) TYPE(*CHAR) LEN(4)
             DCL        VAR(&ENAM3) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ENAM4) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ENAM5) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DBTYP) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&ABTYP) TYPE(*CHAR) LEN(1) VALUE(' ')
