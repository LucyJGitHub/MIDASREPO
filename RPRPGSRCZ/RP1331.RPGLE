     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RP PB Initiation Queues Details.')
      *****************************************************************
      *                                                               *
      *  Midas - Private Banking Module.                              *
      *                                                               *
      *  RP1331 - Read access to Initiation Queues Control File.      *
      *                                                               *
      *  Function: This Module allows to get Initiation Queue Details *
      *                                                               *
      *  Component of: RP1331 - Read access to Initiations Queues.    *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *  Prev Amend No. CPB002  *CREATE    Date 01Jun99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CPB002 - Meridian DBA Middleware Replication Customization.  *
      *                                                               *
      *****************************************************************
 
      **  PB Initiation Queues Control File.
     FRPINIQL1  IF   E           K DISK    USROPN
     F                                     INFSR(*Pssr)
 
      /Eject
      *****************************************************************
      *                                                               *
      *          F U N C T I O N   O F   I N D I C A T O R S          *
      *          -------------------------------------------          *
      *                                                               *
      *  01  -  First time.                                           *
      *                                                               *
      *  91  -  File error.                                           *
      *  92  -  Open error.                                           *
      *  93  -  Close error.                                          *
      *  94  -  Empty file.                                           *
      *  95  -  End of file.                                          *
      *  96  -  No record found.                                      *
      *  97  -  Option error.                                         *
      *  98  -  No selection.                                         *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *                  *************************                    *
      *                  ** INDICATORS NOT USED **                    *
      *                  *************************                    *
      *                                                               *
      *       ***************************************************     *
      *       * xx   02   03   04   05   06   07   08   09   10 *     *
      *       * 11   12   13   14   15   16   17   18   19   20 *     *
      *       * 21   22   23   24   25   26   27   28   29   30 *     *
      *       * 31   32   33   34   35   36   37   38   39   40 *     *
      *       * 41   42   43   44   45   46   47   48   49   50 *     *
      *       * 51   52   53   54   55   56   57   58   59   60 *     *
      *       * 61   62   63   64   65   66   67   68   69   70 *     *
      *       * 71   72   73   74   75   76   77   78   79   80 *     *
      *       * 81   82   83   84   85   86   87   88   89   90 *     *
      *       * xx   xx   xx   xx   xx   xx   xx   xx   99      *     *
      *       ***************************************************     *
      *                                                               *
      *****************************************************************
      /SPACE 3
      *****************************************************************
      *                                                               *
      *                S U B R O U T I N E   I N D E X                *
      *                -------------------------------                *
      *                                                               *
      *  #Insfl - Subroutine to initialise Subfile.                   *
      *  #Infld - Subroutine to initialise Subfile Record Fields.     *
      *  #Sndms - Subroutine to send message to Program Message Queue.*
      *  #Clear - Subroutine to clear Program Message Queue.          *
      *  *Pssr  - Program exception error routine.                    *
      *  *Inzsr - Program Initialization routine.                     *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /Eject
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Array containing Copyright statement
     D Cpy@            S             80    Dim(1) Ctdata Perrcd(1)
 
      ** Midas Local Data Area for database error reporting; based on
      ** external file
     D Lda           E DS           256    Extname(LDA) Dtaara(LDA)
      ** The following fields are defined in the external file:
      **                                    134 141 DBFile
      **                                    142 170 DBKey
      **                                    171 180 DBPgm
      **                                    181 1830DBase
      **                                    184 193 DBMod
      **                                    194 203 DBProc
 
      **  External Data Structure for Initiation Queue Details.
     D D_Fmt         E DS                  Extname(RPINIQPD)
 
      *
      **  First Data Structure for Access Programs, short Data Structure.
     D P_Fmt         E DS                  Extname(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** True and False can be used for indicators being on or off.
     D True            C                   *On
     D False           C                   *Off
 
      **  Work field used to avoid dump to be done more than once.
     D W_RunBefore     S              1A
 
      /Eject
      *****************************************************************
 
      **  Parameters list.
     C     *entry        Plist
     C                   Parm                    P_Rtcd            7            B:Return code
     C                   Parm                    P_Optn            7            I:Option
     C                   Parm                    P_Iniq           48            I:Key field
     C                   Parm                    P_Fmt                          O:Format
 
      *****************************************************************
      *                                                               *
      *                 M A I N  P R O C E S S I N G                  *
      *                                                               *
      *****************************************************************
 
      **  Same option.
     C     P_Optn        Ifeq      '*SAME  '                                    Begin P_Optn
     C     *in01         Comp      False                                  91
     C                   Goto      @SKIP
 
     C                   Endif                                                  End P_Optn
 
      **  Reset error indicators.
     C                   Movea     '000000000'   *in(90)
 
      **  First call - open file :
 
     C     *in01         Ifeq      False                                        Begin first time
     C                   Eval      *in01 = True
     C                   Open      RPINIQL1                             91        Open file
     C     *in91         Cabeq     True          @SKIP                    LR      Open error
 
     C                   Endif                                                  End first time
 
      **  Last call - close file and terminate program:
 
     C     P_Optn        Ifeq      '*FREE  '                                    Begin free
     C                   Close     RPINIQL1                             92        Close file
     C     *in92         Cabeq     True          @SKIP                    LR      Close error
     C                   Eval      *inlr = True
 
     C                   Endif                                                  End free
 
      **  Caller requests first record:
 
     C     P_Optn        Ifeq      '*FIRST '                                    Begin first record
     C     *loval        Setll     RPINIQL1                           9390        Set file
     C     *in93         Cabeq     True          @SKIP                            Empty file
     C     *in90         Cabeq     True          @SKIP                    LR      File error
     C                   Eval      P_Optn = '*NEXT  '                             Force *Next
 
     C                   Endif                                                  End first Record
 
      **  Caller requests next record:
 
     C     P_Optn        Ifeq      '*NEXT  '                                    Begin next record
     C                   Read      RPINIQL1                             9094      Read record
     C     *in94         Cabeq     True          @SKIP                            End of file
     C     *in90         Cabeq     True          @SKIP                    LR      File error
 
     C                   Endif                                                  End next record
 
      **  Caller requests last record:
 
     C     P_Optn        Ifeq      '*LAST  '                                    Begin last record
     C     *hival        Setgt     RPINIQL1                             90        Set file
     C     *in90         Cabeq     True          @SKIP                    LR      File error
     C                   Eval      P_Optn = '*PREV  '                             Force *Prev
 
     C                   Endif                                                  End last record
 
      **  Caller requests previous record:
 
     C     P_Optn        Ifeq      '*PREV  '                                    Begin previous rcd
     C                   Readp     RPINIQL1                             9094      Read record
     C     *in94         Cabeq     True          @SKIP                            End of file
     C     *in90         Cabeq     True          @SKIP                    LR      File error
 
     C                   Endif                                                  End previous record
 
      **  Caller requests record indicated by key:
 
     C     P_Optn        Ifeq      '*KEY   '                                    Begin key
     C     P_Optn        Oreq      '*VERIFY'
     C     P_Iniq        Chain     RPINIQL1                           9590        Get record
     C     *in95         Cabeq     True          @SKIP                            No rec found
     C     *in90         Cabeq     True          @SKIP                    LR      File error
 
     C                   Endif                                                  End key
 
     C     P_Optn        Ifne      '*KEY   '                                    Begin invalid option
     C     P_Optn        Andne     '*NEXT  '
     C     P_Optn        Andne     '*PREV  '
     C     P_Optn        Andne     '*VERIFY'
     C     P_Optn        Andne     '*FREE  '
     C                   Eval      *in96 = True                                   Parm error
 
     C                   Endif                                                  End invalid option
 
      **  No record found or End of file - return error code:
 
      **~~~~~~~~~~~~~~~~~~~~
     C     @SKIP         Tag                                                    ** SKIP Tag **
      **~~~~~~~~~~~~~~~~~~~~
 
     C                   Eval      P_Rtcd  = *BLANK                             No Errors
     C   90              Eval      P_Rtcd  = '*ERROR '                          File error
     C   91              Eval      P_Rtcd  = '*OPEN  '                          Open error
     C   92              Eval      P_Rtcd  = '*CLOSE '                          Close error
     C   93              Eval      P_Rtcd  = '*EMPTY '                          Empty file
     C   94              Eval      P_Rtcd  = '*EOF   '                          End of file
     C   95              Eval      P_Rtcd  = '*NRF   '                          No record found
     C   96              Eval      P_Rtcd  = '*OPTION'                          Option error
     C   97              Eval      P_Rtcd  = '*NOSEL '                          No selection
     C   98              Eval      P_Rtcd  = '*CALL  '                          Called Pgm.err.
      *
     C     P_OPTN        Ifne      '*VERIFY'                                    Begin format
     C     P_OPTN        Andne     '*FREE'
     C     P_RTCD        Andne     '*OPTION'
     C                   Eval      P_Fmt = D_Fmt
 
     C                   Endif                                                  End format
 
      **  Return to caller:
 
     C                   Return
 
      /Eject
      *****************************************************************
      /Title SR/*Pssr
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *  Called by: (**calling routines**)                            *
      *                                                               *
      *  Calls:     program DBERRCTL                                  *
      *                                                               *
      *****************************************************************
 
     C     *Pssr         Begsr                                                  ** *Pssr SR **
 
     C     W_RunBefore   Ifeq      *Blank                                       Begin W_RunBefore
     C                   Eval      W_RunBefore = 'Y'
 
     C                   Dump
 
      **  If program error subroutine is given control for any
      **  file exception.
     C     *lock         In        Lda
     C     DBFILE        Ifeq      *Blanks                                      Begin DBFILE
     C                   Eval      DBPGM  = PSProcMod
     C                   Eval      DBFILE = PSLastFile
     C                   Eval      DBKEY  = PSFileInfo
 
     C                   Endif                                                  End DBFILE
     C                   Out       Lda
 
     C                   Endif                                                  End W_Runbefore
 
     C                   Eval      *inu7 = True
     C                   Eval      *inu8 = True
     C                   Eval      *inlr = True
 
     C                   Return
 
     c                   Endsr
      /Eject
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
