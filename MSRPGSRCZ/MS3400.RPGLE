     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas MS process CMD/MS_CAS_AFT')
      *****************************************************************
      *                                                               *
      *  Midas/SWIFT Direct Link Module                               *
      *                                                               *
      *  MS3300 - Process command MS_CAS_AFT                          *
      *                                                               *
      *  Function:  This program allows Midas/CAS interface (CSW008)  *
      **************to*cutover*to*Automated*File*Transfer*(CSW009)*****         CQQ005
      *             to cutover to Automated File Transfer (CSW009)    *         CQQ005
      *             in circumstances where the CAS interface cannot   *
      *             be used.                                          *
      *                                                               *
      *  Called By: CMD/MS_CAS_AFT                                    *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. 219242             Date 01Jul03               *
      *                 219241             Date 01Jul03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CQQ005             Date 20May99               *
      *                 CSW009 *CREATE     Date 24Jul97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  219242 - Not possible to create MT103+ payment msg from      *
      *           non-FT transaction (Recompile)                      *
      *  219241 - Defaulting of "Details of Charges" assign a         *
      *           system value (Recompile)                            *
      *  CQQ005 - Rename the AFT interface feature to CQQ005 if it is *
      *           being used as a backup to CAS                       *
      *  CSW009 - Midas-SWIFT Alliance Automated File Transfer        *
      *                                                               *
      *****************************************************************
      /EJECT
     Fscsardl0  uf a e           k disk
     Fsdmgmepd  uf   e             disk
      /EJECT
     D cpy@            S             80    dim(1) ctdata perrcd(1)
      ** Array containing Copyright statement
      *
     D dssdy         E DS                  extname(DSSDY)
      ** Data Structures used by access objects
      *
     D sdbank        E DS                  extname(SDBANKPD)
      ** Bank details ICD
      *
     D sdmgme        E DS                  extname(SDMGMEPD)
      ** MG/ME details ICD
      *
     Dn@csw008         s             50    inz('Midas/CAS interface')
     D*n@csw009*********s*************50****inz('Midas-Alliance*AFT*interface') CQQ005
     Dn@cqq005         s             50    inz('AFT interface(backup to CAS)')  CQQ005
      ** Narratives
      *
      /COPY MSCPYSRC,SRERRD
      /EJECT
      *****************************************************************
      *  Index to Subroutines                                         *
      *                                                               *
      *  sr_init       : Initialise program                           *
      *  sr_cutover    : Cutover processing                           *
      *                                                               *
      *****************************************************************
      /EJECT
      *
      ***Input*parameter:*CSW008*or*CSW009*-*feature*to*enable.********         CQQ005
      ** Input parameter: CSW008 or CQQ005 - feature to enable.                 CQQ005
     C     *entry        plist
     C                   parm                    p@opt            11
      *
      ** Set up copyright parameter
     C                   movea     cpy@          cpy2@            80
      *
      ** Initialise program
     C                   exsr      sr_init
      *
      ** perform cutover
     C                   exsr      sr_cutover
      *
      ** Terminate
     C                   move      *on           *inlr
      /EJECT
      **********************************************************************
      * sr_cutover     : Perform cutover process                           *
      * ----------                                                         *
      *                                                                    *
      * Called by      : Mainline                                          *
      *                                                                    *
      * Calls          : -                                                 *
      *                                                                    *
      **********************************************************************
      *
     C     sr_cutover    begsr
      *
      ** Push subroutine
     C                   add       1             Q
     C                   movel     'sr_cutover'  @STK(Q)
      *
      ** Check whether requested feature is already on
     C     p@opt         ifeq      '*CAS_TO_AFT'
     C*******************movel*****'CSW009'******w@feat************6********    CQQ005
     C                   movel     'CQQ005'      w@feat            6            CQQ005
     C                   else
     C                   movel     'CSW008'      w@feat
     C                   endif
      *
     C     w@feat        chain     scsardl0                           55
      *
      ** Continue only if requested feature is currently OFF
     C     *in55         ifeq      *on
      *
      ***If*CSW008*requested*set*this*feature*on*and*CSW009*off*************    CQQ005
      ** If CSW008 requested set this feature on and CQQ005 off                 CQQ005
     C     w@feat        ifeq      'CSW008'
      *
     C*****'CSW009'******chain*****scsardl0***************************50****    CQQ005
     C******in50*********ifeq*******off*************************************    CQQ005
     C*******************delete****scsardl0*********************************    CQQ005
     C*******************endif**********************************************    CQQ005
     C                   call      'SC3011X'                                    CQQ005
     C                   parm                    p0rtn             7            CQQ005
     C                   parm      'D'           pancd             1            CQQ005
     C                   parm      'CQQ005'      psarn             6            CQQ005
     C                   parm                    psard            50            CQQ005
     C                   parm                    pbscd             6            CQQ005
      *
     C*******************movel*****'CSW008'******ABSARN*********************    CQQ005
     C*******************movel*****n@csw008******ABSARD*********************    CQQ005
     C*******************move******##USR*********ABSARD*********************    CQQ005
     C*******************z-add*****BJRDNB********ABLCD**********************    CQQ005
     C*******************movel*****'I'***********ABTYLC*********************    CQQ005
     C*******************write*****@sardl0**********************************    CQQ005
     C                   movel     n@csw008      text             50            CQQ005
     C                   move      ##USR         text                           CQQ005
     C                   call      'SC3011X'                                    CQQ005
     C                   parm                    p0rtn                          CQQ005
     C                   parm      'I'           pancd                          CQQ005
     C                   parm      'CSW008'      psarn                          CQQ005
     C                   parm      text          psard                          CQQ005
     C                   parm                    pbscd                          CQQ005
      *
      ** Change 'protcol used' to CAS
     C     1             chain     sdmgmed0                           60
     C     *in60         ifeq      *off
     C                   movel(p)  'CAS '        ENPRUS
     C                   update    sdmgmed0
     C                   endif
      *
      ** CSW008
     C                   endif
      *
      ***If*CSW009*requested*set*this*feature*on*and*CSW008*off*************    CQQ005
     C*****w@feat********ifeq******'CSW009'*********************************    CQQ005
      ** If CQQ005 requested set this feature on and CSW008 off                 CQQ005
     C     w@feat        ifeq      'CQQ005'                                     CQQ005
      *
     C*****'CSW008'******chain*****scsardl0***************************50****    CQQ005
     C******in50*********ifeq*******off*************************************    CQQ005
     C*******************delete****scsardl0*********************************    CQQ005
     C*******************endif**********************************************    CQQ005
     C                   call      'SC3011X'                                    CQQ005
     C                   parm                    p0rtn                          CQQ005
     C                   parm      'D'           pancd                          CQQ005
     C                   parm      'CSW008'      psarn                          CQQ005
     C                   parm                    psard                          CQQ005
     C                   parm                    pbscd                          CQQ005
      *
     C*******************movel*****'CSW009'******ABSARN*********************    CQQ005
     C*******************movel*****n@csw009******ABSARD*********************    CQQ005
     C*******************move******##USR*********ABSARD*********************    CQQ005
     C*******************z-add*****BJRDNB********ABLCD**********************    CQQ005
     C*******************movel*****'I'***********ABTYLC*********************    CQQ005
     C*******************write*****@sardl0**********************************    CQQ005
     C                   movel     n@cqq005      text                           CQQ005
     C                   move      ##USR         text                           CQQ005
     C                   call      'SC3011X'                                    CQQ005
     C                   parm                    p0rtn                          CQQ005
     C                   parm      'I'           pancd                          CQQ005
     C                   parm      'CQQ005'      psarn                          CQQ005
     C                   parm      text          psard                          CQQ005
     C                   parm                    pbscd                          CQQ005
      *
      ** Change 'protcol used' to AFT
     C     1             chain     sdmgmed0                           60
     C     *in60         ifeq      *off
     C                   movel(p)  'AFT '        ENPRUS
     C                   update    sdmgmed0
     C                   endif
      *
      ***Call*ICD*maintenance*for*CSW009************************************    CQQ005
      ** Call ICD maintenance for CQQ005                                        CQQ005
     C                   call      'SD9283R'
     C                   parm      *blanks       p0rtn             7
     C                   parm      sdmgme        p1parm          382
     C                   parm      *blanks       WP0001            5
      *
      ***CSW009*************************************************************    CQQ005
      ** CQQ005
     C                   endif
      *
      ** Already on
     C                   endif
      *
      ** Pop subroutine
     C                   clear                   @STK(Q)
     C                   sub       1             Q
     C                   endsr
      /EJECT
      **********************************************************************
      * sr_init        : Initialise program                                *
      * -------                                                            *
      *                                                                    *
      * Called by      : Mainline                                          *
      *                                                                    *
      * Calls          : -                                                 *
      *                                                                    *
      **********************************************************************
      *
     C     sr_init       begsr
      *
      ** Push subroutine
     C                   add       1             Q
     C                   movel     'sr_init'     @STK(Q)
      *
      ** Access bank details
     C                   call      'AOBANKR0'
     C                   parm      *blanks       p@rtcd            7
     C                   parm      '*FIRST'      p@optn            7
     C     sdbank        parm      *blanks       dssdy
      *
      ** If the Access Object returns an error code, database error
     C     p@rtcd        ifne      *blank
     C                   movel     'AOBANKR0'    w0file
     C                   movel     'Bank details'w0key
     C                   z-add     01            w0ernb
     C                   movel     'MEM5003'     w0msgd
     C                   movel     'MIDAS  '     w0msgf
     C                   exsr      srerr
     C                   endif
      *
      ** Pop subroutine
     C                   clear                   @STK(Q)
     C                   sub       1             Q
     C                   endsr
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
      *
     C                   END
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      ********************************************************************
      *
     C                   ENDSR
      *
      ********************************************************************
      /COPY MSCPYSRC,SRERRC
**  CPY@
(c) Finastra International Limited 2001
