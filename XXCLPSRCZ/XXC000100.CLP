/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GL Remap Interbranch Postings')                 */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/*       CLP/XXC000100 - Remap Interbranch Postings                  */
/*                                                                   */
/*       (c) Copyright Finastra Ltd 2019                             */
/*                                                                   */
/*       Last Amend No. LUC118 *CREATE     Date 13Feb19              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       LUC118 - Upgrade of S21045 to FB Midas 2.1                  */
/*                BV Auto transfer of interbranch account balances   */
/*                                                                   */
/*********************************************************************/

             PGM        PARM(&FILE)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)

/*  Create a subset of BVINTBR, containing only those accounts       */
/*   which actually exist (to compensate for bad DFU'ing etc.)       */

             CLOF       OPNID(BVINTBR)
             MONMSG CPF0000
             DLTF QTEMP/BVINTTEMP
             MONMSG CPF0000
             OPNQRYF    FILE((BVINTBR) (ACCNTAB)) FORMAT(BVINTBR) +
                          QRYSLT('reci=''D''') JFLD((1/NOBRC 2/BRCA +
                          *EQ) (1/NOCNUM 2/CNUM) (1/NOCCY 2/CCY) +
                          (1/NOACOD 2/ACOD) (1/NOACSQ 2/ACSQ))
             CPYFRMQRYF FROMOPNID(BVINTBR) TOFILE(QTEMP/BVINTTEMP) +
                          CRTFILE(*YES)
             CLOF       OPNID(BVINTBR)
             MONMSG CPF0000

/* XXAPOSX1 has one member for each posting file                   */

             CLRPFM     FILE(XXAPOSX1) MBR(&FILE)
             CLOF       OPNID(&FILE)
             MONMSG CPF0000

/* Copy to XXAPOSX1 postings to a/cs not referenced on BVINTTEMP   */

             OPNQRYF    FILE((&FILE) (BVINTTEMP)) FORMAT(&FILE) +
                          JFLD((1/BRCA 2/IBBRC *EQ) (1/CNUM +
                          2/IBCNUM) (1/CCY 2/IBCCY) (1/ACOD +
                          2/IBACOD) (1/ACSQ 2/IBACSQ)) +
                          JDFTVAL(*ONLYDFT)
             CPYFRMQRYF FROMOPNID(&FILE) TOFILE(XXAPOSX1) TOMBR(&FILE) MBROPT(*ADD)
             CLOF       OPNID(&FILE)
             MONMSG CPF0000

/* Copy to XXAPOSX1 postings to accounts referenced on BVINTTEMP,  */
/*  changing the account reference to the "to" a/c on BVINTTEMP      */
/*  First, Retail postings                                           */

             OPNQRYF    FILE((&FILE) (BVINTTEMP) (ACCNTAB)) +
                          FORMAT(&FILE) QRYSLT('atyp=''R''') +
                          JFLD((1/BRCA 2/IBBRC *EQ) (1/CNUM +
                          2/IBCNUM) (1/CCY 2/IBCCY) (1/ACOD +
                          2/IBACOD) (1/ACSQ 2/IBACSQ) (2/NOBRC +
                          3/BRCA) (2/NOCNUM 3/CNUM) (2/NOCCY 3/CCY) +
                          (2/NOACOD 3/ACOD) (2/NOACSQ 3/ACSQ)) +
                          JDFTVAL(*NO) MAPFLD((BRCA NOBRC) (CNUM +
                          NOCNUM) (CCY NOCCY) (ACOD NOACOD) (ACSQ +
                          NOACSQ) (ACODQQ '1/acodqq') (ATYP '3/atyp') (STYP '3/styp') +
                          (ACNO '3/acno') (RECI '1/reci') (PRFC +
                          '1/prfc') (ZZ002 '1/zz002') (RIND 1) +
                          (RRNM '1/RRNM')) IGNDECERR(*YES)
             CPYFRMQRYF FROMOPNID(&FILE) TOFILE(XXAPOSX1) TOMBR(&FILE) MBROPT(*ADD)
             CLOF       OPNID(&FILE)
             MONMSG CPF0000

/*  Second, non-Retail postings                                      */

             OPNQRYF    FILE((&FILE) (BVINTTEMP) (ACCNTAB)) +
                          FORMAT(&FILE) QRYSLT('atyp *NE ''R''') +
                          JFLD((1/BRCA 2/IBBRC *EQ) (1/CNUM +
                          2/IBCNUM) (1/CCY 2/IBCCY) (1/ACOD +
                          2/IBACOD) (1/ACSQ 2/IBACSQ) (2/NOBRC +
                          3/BRCA) (2/NOCNUM 3/CNUM) (2/NOCCY 3/CCY) +
                          (2/NOACOD 3/ACOD) (2/NOACSQ 3/ACSQ)) +
                          JDFTVAL(*NO) MAPFLD((BRCA NOBRC) (CNUM +
                          NOCNUM) (CCY NOCCY) (ACOD NOACOD) (ACSQ +
                          NOACSQ) (ACODQQ '1/acodqq') (ATYP '3/atyp') (STYP '3/styp') +
                          (ACNO '3/acno') (RECI '1/reci') (PRFC +
                          '1/prfc') (ZZ002 '1/zz002') (RIND 0) +
                          (RRNM '1/RRNM')) IGNDECERR(*YES)
             CPYFRMQRYF FROMOPNID(&FILE) TOFILE(XXAPOSX1) TOMBR(&FILE) MBROPT(*ADD)
             CLOF       OPNID(&FILE)
             MONMSG CPF0000
             CLRPFM &FILE

/* Copy the file back to the original posting file                   */

             CPYF       FROMFILE(XXAPOSX1) TOFILE(&FILE) FROMMBR(&FILE) MBROPT(*ADD)
             DLTF QTEMP/BVINTTEMP
             MONMSG CPF0000


             ENDPGM
